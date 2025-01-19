import 'config.dart';
import 'dart:convert';
import 'package:mutex/mutex.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> makeRequest(
  String method,
  String endpoint,
  final axios,
  [Map<String, dynamic>? body]
) async {
  http.Response response = method == 'GET' ?
    await axios.get(endpoint) :
    await axios.post(endpoint, body, headers: {'Content-Type': 'application/json'});
  if (response.statusCode < 200 || response.statusCode > 299) {
    throw Exception('Failed to $method $endpoint: ${response.statusCode}');
  }
  return json.decode(response.body);
}

void discardFromBody(Map<String, dynamic> body, {required List<String> fields}) {
  for (String field in fields) {
    body.remove(field);
  }
}

void validateBody(
  Map<String, dynamic> body,
  {required List<String> fields}
) {
  for (String field in fields) {
    if (body[field] == null) {
      throw Exception('$field is required');
    }
    else if (body[field].runtimeType == String && body[field] == '') {
      throw Exception('$field cannot be empty');
    }
  }
}

void populateBody(
  Map<String, dynamic> body,
  {required Map<String, dynamic> defaultFields}
) {
  defaultFields.forEach((key,value) {
    if (body[key] == null) {
      body[key] = value;
    }
  });
}

Map<String, dynamic> extractFromBody(
  Map<String, dynamic> body,
  {required List<String> fields}
) {
  final extracted = <String, dynamic>{};
  for (String field in fields) {
    if (body[field] != null) {
      extracted[field] = body[field];
      body.remove(field);
    }
  }
  return extracted;
}

Map<String, Map<String, dynamic>> splitBody(
  Map<String, dynamic> body,
  {required String mediaType}
) {
  final mapping = {
    'mediaBody': [
      'originalname',
      'description',
      'releasedate',
      'criticscore',
      'communityscore',
      'mediatype',
    ],
    // 'mediauserBody': [
    //   'coverimage',
    //   'icon',
    //   'backgroundimage', // the user chooses from the artworks provided by the api and the backend only receives one image
    // ],
    'genresBody': ['genres'],
    'creatorsBody': ['creators'],
    'publishersBody': ['publishers'],
    'platformsBody': ['platforms'],
    'linksBody': ['links'],
    'retailersBody': ['retailers'],
    'seriesBody': ['seriesname'],
    'mediaseriesBody': ['series'],
  };

  final result = <String, Map<String, dynamic>>{};
  mapping.forEach((key, value) {
    result[key] = extractFromBody(body, fields: value);
  });
  result['${mediaType}Body'] = body;

  return result;
}

Map<String, dynamic> createAttributes(
  String tableName,
  dynamic entry
) {
  if (tableName != 'link') {
    return {'name' : entry};
  }

  return {
    'href' : entry,
    'name' : entry
      .replaceAll('http://', '')
      .replaceAll('https://', '')
      .split('/')[0], // TODO: more complex mapping later,
  };
}

Future<Map<String, dynamic>> createEntriesHelper(
  Map<String, dynamic> body,
  String tableName,
  String endpoint,
  int mediaId,
  Future<Map<String, dynamic>> Function(dynamic, dynamic) postRequest,
  Future<Map<String, dynamic>> Function(dynamic, dynamic) getByNameRequest
) async {
  final result = <String, dynamic> {};

  result[endpoint] = [];
  result['media$endpoint'] = [];
  final mutex = Mutex();

  if (body[endpoint].isEmpty) {
    return result;
  }

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
        .then((value) => value as Map<String, dynamic>);

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

Future<Map<String, dynamic>> createFromBody(
  Map<String, Map<String, dynamic>> body,
  final supabase,
  {required String mediaType,
  required String mediaTypePlural}
) async {
  final axios = Config().axios;
  Map<String, dynamic> result = <String, dynamic>{};

  Future<Map<String, dynamic>> postRequest(body, endpoint) async =>
    await makeRequest('POST', '/$endpoint', axios, body);
  Future<Map<String, dynamic>> getByNameRequest(name, endpoint) async =>
    await makeRequest('GET', '/$endpoint/name?query=$name', axios);
  Future<Map<String, dynamic>> createTable(body, tableName, endpoint, mediaId) async =>
    await createEntriesHelper(body, tableName, endpoint, mediaId, postRequest, getByNameRequest);

  // Create Media from body
  result['media'] = await postRequest(body['mediaBody']!, 'medias');

  // Create MediaType from body
  body['${mediaType}Body']?['mediaid'] = result['media']?['id'];
  Map<String, dynamic> partialResult = await supabase
    .from(mediaType)
    .insert(body['${mediaType}Body']!)
    .select()
    .single();
  partialResult.forEach((key, value) => result[key] = value);

  // Create X=creators/publishers/platforms/links/retailers/series and mediaX from body
  final mapToPlural = {
    'creator'  : 'creators',
    'publisher': 'publishers',
    'platform' : 'platforms',
    'link'     : 'links',
    'retailer' : 'retailers',
    'genre'    : 'genres',
  };
  final mutex = Mutex();

  await Future.wait(
    mapToPlural.entries.map((entry) => () async {
        final response = await createTable(body['${entry.value}Body']!, entry.key, entry.value, result['media']?['id']);
        await mutex.protect(() async {
          result[entry.value] = response[entry.value];
          result['media${entry.value}'] = response['media${entry.value}'];
          if (result[entry.value].isEmpty) {
            result.remove(entry.value);
          }
          if (result['media${entry.value}'].isEmpty) {
            result.remove('media${entry.value}');
          }
        });
      }()
    )
  );

  if (body['seriesBody'] == null) {
    return result;
  }

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
  if (result['series'].isEmpty) {
    result.remove('series');
  }

  if(body['mediaseriesBody']?['series'].length == 0) {
    return result;
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
      entryBody = await getByNameRequest(mediaId.toString(), mediaTypePlural);
    }
    catch (_) {
      entryBody = await supabase
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

  if (result['new_related_medias'].isEmpty) {
    result.remove('new_related_medias');
  }
  if (result['new_related_$mediaType'].isEmpty) {
    result.remove('new_related_$mediaType');
  }
  if (result['mediaseries'].isEmpty) {
    result.remove('mediaseries');
  }

  return result;
}