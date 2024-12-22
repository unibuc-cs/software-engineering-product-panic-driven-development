import 'config.dart';
import 'dart:convert';
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

Future<Map<String,dynamic>> makePostRequest(
  Map<String, dynamic> body,
  String endpoint,
  final axios
) async {
  return await makeRequest('POST', '/$endpoint', axios, body);
}

Future<Map<String,dynamic>> makeGetByNameRequest(
  String endpoint,
  String name,
  final axios
) async {
  return await makeRequest('GET', '/$endpoint/name?query=$name', axios);
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
    'mediauserBody': [
      'coverimage',
      'icon',
      'backgroundimage',
    ],
    'genresBody': ['genres'],
    'creatorsBody': ['creators'],
    'publishersBody': ['publishers'],
    'platformsBody': ['platforms'],
    'linksBody': ['links'],
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
  final result = <String, dynamic> {};

  if (tableName == 'link') {
    result['name'] = entry
      .replaceAll('http://', '')
      .replaceAll('https://', '')
      .split('/')[0]; // TO DO: more complex mapping later
    result['href'] = entry;
  }
  else { // creator, publisher, platform
      result['name'] = entry;
  }

  return result;
}

Future<Map<String, dynamic>> doCreateTable(
  Map<String, dynamic> body,
  String tableName,
  String tableEndpoint,
  int mediaId,
  Future<Map<String, dynamic>> Function(dynamic, dynamic) postRequest,
  Future<Map<String, dynamic>> Function(dynamic, dynamic) getByNameRequest
) async {
  final result = <String, dynamic> {};

  result[tableEndpoint] = [];
  result['media$tableEndpoint'] = [];
  dynamic entries = body[tableEndpoint];
  for (var entry in entries) {
    Map<String, dynamic> entryBody = <String, dynamic>{};
    final attributes = createAttributes(tableName, entry);
    try {
      entryBody = await getByNameRequest(tableEndpoint, attributes['href'] ?? attributes['name']);
    }
    catch (_) {
      entryBody = await postRequest(
        attributes,
        tableEndpoint,
      );
      result[tableEndpoint].add(entryBody);
    }
    finally {
      final response = await postRequest(
        {
          'mediaid': mediaId,
          '${tableName}id': entryBody['id'],
        },
        'media$tableEndpoint',
      );
      result['media$tableEndpoint'].add(response);
    }
  }

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

  Future<Map<String, dynamic>> postRequest(body, table) async =>
    await makePostRequest(body, table, axios);
  Future<Map<String, dynamic>> getByNameRequest(table, name) async =>
    await makeGetByNameRequest(table, name, axios);
  Future<Map<String, dynamic>> createTable(body, tableName, tableEndpoint, mediaId) async =>
    await doCreateTable(body, tableName, tableEndpoint, mediaId, postRequest, getByNameRequest);

  // Create media from body
  result['media'] = await postRequest(body['mediaBody']!, 'medias');

  // Create mediaType from body
  body['${mediaType}Body']?['mediaid'] = result['media']?['id'];
  Map<String, dynamic> partialResult = await supabase
    .from(mediaType)
    .insert(body['${mediaType}Body']!)
    .select()
    .single();
  partialResult.forEach((key, value) => result[key] = value);

  // TO DO: create mediauser from body

  // TO DO: Create mediausergenres from body

  // Create X=creators/publishers/platforms/links/series and mediaX from body
  final mapToPlural = {
    'creator'  : 'creators',
    'publisher': 'publishers',
    'platform' : 'platforms',
    'link'     : 'links',
  };
  for (MapEntry<String, dynamic> entry in mapToPlural.entries) {
    final response = await createTable(body['${entry.value}Body']!, entry.key, entry.value, result['media']?['id']);
    result[entry.value] = response[entry.value];
    result['media${entry.value}'] = response['media${entry.value}'];
    if (result[entry.value].isEmpty) {
      result.remove(entry.value);
    }
  }

  if (body['seriesBody'] == null) {
    return result;
  }

  // Create series and mediaseries from body
  final aux = [];
  result['series'] = [];
  for (var entry in body['seriesBody']?['seriesname']) {
    Map<String, dynamic> entryBody = <String, dynamic>{};
    final attributes = createAttributes('series', entry);
    try {
      entryBody = await getByNameRequest('series', attributes['name']);
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


  // Check here in case of errors with the series
  int mediaId = 0, seriesId = aux[0]['id'];
  result['new_related_medias'] = [];
  result['new_related_$mediaType'] = [];
  result['mediaseries'] = [];
  for (var entry in body['mediaseriesBody']?['series']) {
    Map<String, dynamic> entryBody = <String, dynamic>{};

    // Create media
    try {
      entryBody = await getByNameRequest('medias', entry['name']);
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
      entryBody = await getByNameRequest(mediaTypePlural, mediaId.toString());
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