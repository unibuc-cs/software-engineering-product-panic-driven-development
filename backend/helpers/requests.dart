import 'config.dart';
import 'dart:convert';
import 'responses.dart';
import 'db.dart';
import 'package:mutex/mutex.dart';
import 'package:http/http.dart' as http;
import 'package:shelf_plus/shelf_plus.dart';

void populateBody(Map<String, dynamic> body, {required Map<String, dynamic> defaultFields}) {
  defaultFields.forEach((key, value) {
    if (body[key] == null) {
      body[key] = value;
    }
  });
}

void discardFromBody(Map<String, dynamic> body, {required List<String> fields}) {
  for (String field in fields) {
    body.remove(field);
  }
}

void validateFromBody(Map<String, dynamic> body, {required List<String> fields}) {
  for (String field in fields) {
    if (body[field] == null) {
      throw Exception('$field is required');
    }
    else if (body[field].runtimeType == String && body[field] == '') {
      throw Exception('$field cannot be empty');
    }
  }
}

Future<Map<String, dynamic>> _makeRequest(
  String method,
  String endpoint,
  [Map<String, dynamic>? body]
) async {
  final axios = Config.instance.axios;
  http.Response response = method == 'GET' ?
    await axios.get(endpoint) :
    await axios.post(endpoint, body, headers: {'Content-Type': 'application/json'});
  if (response.statusCode < 200 || response.statusCode > 299) {
    throw Exception('Failed to $method $endpoint: ${response.statusCode}');
  }
  return json.decode(response.body);
}

Future<Map<String, dynamic>> postRequest(body, endpoint) async =>
  await _makeRequest('POST', '/$endpoint', body);

Future<Map<String, dynamic>> getByNameRequest(name, endpoint) async =>
  await _makeRequest('GET', '/$endpoint/name?query=$name');

String _extractLinkName(String entry) => entry.replaceAll(RegExp(r'^https?://'), '').split('/')[0];

Map<String, dynamic> createAttributes(String tableName, dynamic entry) => tableName == 'link'
  ? {'name': _extractLinkName(entry), 'href': entry}
  : {'name': entry};

Future<Response> createMediaType(Map<String, dynamic> initialBody) async {
  String getPlural(String mediaType) =>
    {
      'book' : 'books',
      'game' : 'games',
      'movie': 'movies',
    }[mediaType] ?? mediaType;

  void removeIfEmpty(Map<String, dynamic> result, String key) {
    if (result[key] != null && result[key]!.isEmpty) {
      result.remove(key);
    }
  }

  Future<void> addToList(List<dynamic> list, dynamic value, Mutex mutex) async {
    await mutex.protect(() async => list.add(value));
  }

  Future<void> setInResultIfNotEmpty(Map<String, dynamic> result, String key, dynamic value, Mutex mutex) async {
    if (value != null && value!.isNotEmpty) {
      await mutex.protect(() async => result[key] = value);
    }
  }

  Map<String, Map<String, dynamic>> splitBody(Map<String, dynamic> body) {
    final result = <String, Map<String, dynamic>>{};
    final mediaType = body['mediatype'];
    final mapping = {
      'genresBody'     : ['genres'],
      'creatorsBody'   : ['creators'],
      'publishersBody' : ['publishers'],
      'platformsBody'  : ['platforms'],
      'linksBody'      : ['links'],
      'retailersBody'  : ['retailers'],
      'seriesBody'     : ['seriesname'],
      'mediaseriesBody': ['series'],
      'seasonsBody'    : ['seasons'],
      'mediaBody'      : [
        'originalname',
        'description',
        'releasedate',
        'criticscore',
        'communityscore',
        'mediatype',
      ],
    };

    mapping.forEach((key, fields) {
      result[key] = <String, dynamic>{};
      for (String field in fields) {
        if (body[field] != null) {
          result[key]![field] = body[field];
          body.remove(field);
        }
      }
    });
    result['${mediaType}Body'] = body;

    return result;
  }

  Future<Map<String, dynamic>> createResources(Map<String, dynamic> body, int mediaId, String endpoint) async {
    final result = <String, dynamic> {
      endpoint        : [],
      'media$endpoint': [],
    };
    if (body[endpoint].isEmpty) {
      return result;
    }

    final tableName = endpoint.substring(0, endpoint.length - 1);
    final mutex = Mutex();
    List<Future<dynamic>> tasks = [];

    for (var entry in body[endpoint]) {
      tasks.add(() async {
        final attributes = createAttributes(tableName, entry);
        dynamic id = (await getByNameRequest(attributes['href'] ?? attributes['name'], endpoint)
          .catchError((_) async {
            final body = await postRequest(attributes, endpoint);
            await addToList(result[endpoint], body, mutex);
            return body;
          })
          .then((value) => value)
        )['id'];

        final response = await postRequest(
          {
            'mediaid': mediaId,
            '${tableName}id': id,
          },
          'media$endpoint',
        );
        await addToList(result['media$endpoint'], response, mutex);
      }());
    }
    await Future.wait(tasks);

    return result;
  }

  final mediaType = initialBody['mediatype'];
  final mediaTypePlural = getPlural(mediaType);
  final endpoints = [
    'links',
    'genres',
    'creators',
    'platforms',
    'retailers',
    'publishers',
  ];
  final result = <String, dynamic>{
    'series'                  : [],
    'related_medias'          : [],
    'related_$mediaTypePlural': [],
    'mediaseries'             : [],
    'seasons'                 : [],
  };
  final body = splitBody(initialBody);
  final Mutex resultMutex = Mutex();

  // Create Media from body
  result['media'] = await postRequest(body['mediaBody']!, 'medias');

  // Create MediaType from body
  body['${mediaType}Body']?['mediaid'] = result['media']?['id'];
  (await SupabaseManager
    .client
    .from(mediaType)
    .insert(body['${mediaType}Body']!)
    .select()
    .single()
  ).forEach((key, value) => result[key] = value);

  // Create X=creators/publishers/platforms/links/retailers/series and mediaX from body
  await Future.wait(endpoints
    .map((endpoint) => () async {
      final response = await createResources(body['${endpoint}Body']!, result['media']?['id'], endpoint);
      await setInResultIfNotEmpty(result, endpoint, response[endpoint], resultMutex);
      await setInResultIfNotEmpty(result, 'media${endpoint}', response['media${endpoint}'], resultMutex);
    }())
  );

  if (body.containsKey('seasonsBody') && body['seasonsBody']!.isNotEmpty) {
    try {
      Mutex seasonMutex = Mutex();

      List<Future<dynamic>> tasks = [];

      body['seasonsBody']!['seasons'].forEach((season) {
        final seasonBody = {
          '${mediaType.replaceAll('_', '')}id': result['id'],
          ...season,
        };

        tasks.add(() async {
          var seasonResponse = (await SupabaseManager
            .client
            .from('season')
            .insert(seasonBody)
            .select()
            .single()
          );

          await addToList(result['seasons'], seasonResponse, seasonMutex);
        }());
      });

      await Future.wait(tasks);
    }
    catch(e) {
      print(e);
    }
  }
  removeIfEmpty(result, 'seasons');

  if (body['seriesBody'] == null) {
    removeIfEmpty(result, 'related_medias');
    removeIfEmpty(result, 'related_$mediaTypePlural');
    removeIfEmpty(result, 'mediaseries');
    return sendOk(result);
  }

  // Create series and mediaseries from body
  final seriesList = [];
  final Mutex seriesListMutex = Mutex();
  final List<Future<dynamic>> tasks = [];

  for (var entry in body['seriesBody']?['seriesname']) {
    if (entry == null) {
      continue;
    }

    tasks.add(() async {
      final attributes = createAttributes('series', entry);
      await getByNameRequest(attributes['name'], 'series')
        .catchError((_) async {
          final body = await postRequest(attributes, 'series');
          await addToList(result['series'], body, resultMutex);
          return body;
        })
        .then((value) async => await addToList(seriesList, value, seriesListMutex));
    }());
  }
  await Future.wait(tasks);
  removeIfEmpty(result, 'series');

  if (body['mediaseriesBody']?['series'].length == 0) {
    removeIfEmpty(result, 'related_medias');
    removeIfEmpty(result, 'related_$mediaTypePlural');
    removeIfEmpty(result, 'mediaseries');
    return sendOk(result);
  }

  // Check here in case of errors with the series
  int seriesId = seriesList[0]['id'];
  tasks.clear();

  for (var entry in body['mediaseriesBody']?['series']) {
    tasks.add(() async {
      // Create media
      int mediaId = (await getByNameRequest(entry['name'], 'medias')
        .catchError((_) async {
          final body = await postRequest(
            {
              'originalname': entry['name'],
              'mediatype'   : mediaType,
            },
            'medias',
          );
          await addToList(result['related_medias'], body, resultMutex);
          return body;
        })
        .then((value) => value)
      )['id'];

      // Create mediaType
      await getByNameRequest(mediaId.toString(), mediaTypePlural)
        .catchError((_) async {
          final body = await SupabaseManager
            .client
            .from(mediaType)
            .insert({'mediaid' : mediaId})
            .select()
            .single();
          await addToList(result['related_$mediaTypePlural'], body, resultMutex);
          return body;
        });

      // Create mediaseries
      await postRequest(
        {
          'mediaid' : mediaId,
          'seriesid': seriesId,
          'index'   : entry['index'],
        },
        'mediaseries',
      )
      .then((value) async => await addToList(result['mediaseries'], value, resultMutex))
      .catchError((_) => {});
    }());
  }
  await Future.wait(tasks);

  removeIfEmpty(result, 'related_medias');
  removeIfEmpty(result, 'related_$mediaTypePlural');
  removeIfEmpty(result, 'mediaseries');

  return sendOk(result);
}
