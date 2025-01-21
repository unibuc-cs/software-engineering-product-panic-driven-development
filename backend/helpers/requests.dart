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

  Map<String, Map<String, dynamic>> splitBody(Map<String, dynamic> body) {
    final result = <String, Map<String, dynamic>>{};
    final mediaType = body['mediatype'] as String;
    final mapping = {
      'genresBody'     : ['genres'],
      'creatorsBody'   : ['creators'],
      'publishersBody' : ['publishers'],
      'platformsBody'  : ['platforms'],
      'linksBody'      : ['links'],
      'retailersBody'  : ['retailers'],
      'seriesBody'     : ['seriesname'],
      'mediaseriesBody': ['series'],
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
    final result = <String, dynamic> {};
    if (body[endpoint].isEmpty) {
      return result;
    }

    final tableName = endpoint.substring(0, endpoint.length - 1);
    final mutex = Mutex();
    result[endpoint] = [];
    result['media$endpoint'] = [];

    List<Future<dynamic>> tasks = [];
    for (var entry in body[endpoint]) {
      tasks.add(() async {
        Future<void> addToResult(String key, dynamic value) async {
          await mutex.protect(() async => result[key].add(value));
        }

        final attributes = createAttributes(tableName, entry);
        Map<String, dynamic> entryBody = await getByNameRequest(attributes['href'] ?? attributes['name'], endpoint)
          .catchError((_) async {
            final body = await postRequest(attributes, endpoint);
            await addToResult(endpoint, body);
            return body;
          })
          .then((value) => value);

        final response = await postRequest(
          {
            'mediaid': mediaId,
            '${tableName}id': entryBody['id'],
          },
          'media$endpoint',
        );
        await addToResult('media$endpoint', response);
      }());
    }
    await Future.wait(tasks);

    return result;
  }

  final mediaType = initialBody['mediatype'] as String;
  final endpoints = {
    'creators',
    'publishers',
    'platforms',
    'links',
    'retailers',
    'genres',
  };
  final mutex = Mutex();
  Map<String, dynamic> result = <String, dynamic>{};
  Map<String, Map<String, dynamic>> body = splitBody(initialBody);

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
      await mutex.protect(() async {
        result[endpoint] = response[endpoint];
        removeIfEmpty(result, endpoint);
        result['media${endpoint}'] = response['media${endpoint}'];
        removeIfEmpty(result, 'media$endpoint');
      });
    }())
  );

  if (body['seriesBody'] == null) {
    return sendOk(result);
  }

  // TODO: make this concurrent and improve the code
  // Create series and mediaseries from body
  final aux = [];
  result['series'] = [];
  for (var entry in body['seriesBody']?['seriesname']) {
    if (entry == null) {
      continue;
    }

    Map<String, dynamic> entryBody = <String, dynamic>{};
    final attributes = createAttributes('series', entry);
    try {
      entryBody = await getByNameRequest(attributes['name'], 'series');
      aux.add(entryBody);
    }
    catch (_) {
      entryBody = await postRequest(
        attributes,
        'series',
      );
      aux.add(entryBody);
      result['series'].add(entryBody);
    }
  }
  removeIfEmpty(result, 'series');

  if (body['mediaseriesBody']?['series'].length == 0) {
    return sendOk(result);
  }

  // Check here in case of errors with the series
  int mediaId = 0, seriesId = aux[0]['id'];
  result['new_related_medias'] = [];
  result['new_related_$mediaType'] = [];
  result['mediaseries'] = [];
  for (var entry in body['mediaseriesBody']?['series']) {
    Map<String, dynamic> entryBody = <String, dynamic>{};

    // Create media
    try {
      entryBody = await getByNameRequest(entry['name'], 'medias');
    }
    catch (_) {
      entryBody = await postRequest(
        {
          'originalname': entry['name'],
          'releasedate': DateTime.now().toIso8601String(),
          'mediatype': mediaType,
        },
        'medias',
      );
      result['new_related_medias'].add(entryBody);
    }
    mediaId = entryBody['id'];

    // Create mediaType
    try {
      entryBody = await getByNameRequest(mediaId.toString(), getPlural(mediaType));
    }
    catch (_) {
      entryBody = await SupabaseManager
        .client
        .from(mediaType)
        .insert({'mediaid' : mediaId})
        .select()
        .single();
      result['new_related_$mediaType'].add(entryBody);
    }

    // Create mediaseries
    try {
      entryBody = await postRequest(
        {
          'mediaid' : mediaId,
          'seriesid': seriesId,
          'index'   : entry['index'],
        },
        'mediaseries',
      );
      result['mediaseries'].add(entryBody);
    }
    catch (_) {}
  }

  removeIfEmpty(result, 'new_related_medias');
  removeIfEmpty(result, 'new_related_$mediaType');
  removeIfEmpty(result, 'mediaseries');

  return sendOk(result);
}
