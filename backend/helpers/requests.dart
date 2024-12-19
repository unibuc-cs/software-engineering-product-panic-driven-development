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
  fields.forEach((field) {
    body.remove(field);
  });
}

void validateBody(
  Map<String, dynamic> body,
  {required List<String> fields}
) {
  fields.forEach((field) {
    if (body[field] == null) {
      throw Exception('$field is required');
    }
    else if (body[field].runtimeType == String && body[field] == '') {
      throw Exception('$field cannot be empty');
    }
  });
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
  fields.forEach((field) {
    if (body[field] != null) {
      extracted[field] = body[field];
      body.remove(field);
    }
  });
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
    'creatorsBody': ['creators'],
    'publishersBody': ['publishers'],
    'platformsBody': ['platforms'],
    'linksBody': ['links'],
    'seriesBody': ['seriesname'],
    'mediaseriesBody': ['series'],
    'genresBody': ['genres'],
  };

  final result = <String, Map<String, dynamic>>{};
  mapping.forEach((key, value) {
    result[key] = extractFromBody(body, fields: value);
  });
  result['${mediaType}Body'] = body;

  return result;
}

Future<Map<String, dynamic>> createFromBody(
  Map<String, Map<String, dynamic>> body,
  final supabase,
  {required String mediaType}
) async {
  final axios = Config().axios;
  Map<String, dynamic> result = <String, dynamic>{};

  Future<Map<String, dynamic>> postRequest(body, table) async => await makePostRequest(body, table, axios);
  Future<Map<String, dynamic>> getByNameRequest(table, name) async => await makeGetByNameRequest(table, name, axios);

  // Create media from body
  result['media'] = await postRequest(body['mediaBody']!, 'medias');

  // Create mediaType from body
  body['${mediaType}Body']?['mediaid'] = result['media']?['id'];
  result[mediaType] = await supabase
    .from(mediaType)
    .insert(body['${mediaType}Body']!)
    .select()
    .single();

  // TO DO: create mediauser from body

  // Create creators and mediacreators from body
  result['creators'] = [];
  dynamic creators = body['creatorsBody']?['creators'];
  for (var creator in creators) {
    Map<String, dynamic> creatorBody = <String, dynamic>{};
    try {
      creatorBody = await getByNameRequest('creators', creator);
    }
    catch (_) {
      creatorBody = await postRequest(
        {
          'name': creator,
        },
        'creators'
      );
    }
    await postRequest(
      {
        'mediaid': result['media']['id'],
        'creatorid': creatorBody['id'],
      },
      'mediacreators'
    );
    result['creators'].add(creatorBody);
  }

  // TO DO: Create publishers from body

  // TO DO: Create platforms from body

  // TO DO: Create links from body

  // TO DO: Create series from body

  // TO DO: Create mediausergenres from body

  return result;
}