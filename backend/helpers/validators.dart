import 'config.dart';
import 'dart:convert';
import 'db_connection.dart';
import 'package:http/http.dart' as http;

void discardFromBody(Map<String, dynamic> body, {required List<String> fields}) {
  for (var field in fields) {
    if (body[field] != null) {
      body.remove(field);
    }
  }
}

void validateBody(Map<String, dynamic> body, {required List<String> fields}) {
  for (var field in fields) {
    if (body[field] == null) {
      throw Exception('$field is required');
    }
    else if (body[field].runtimeType == String && body[field] == '') {
      throw Exception('$field cannot be empty');
    }
  }
}

void populateBody(Map<String, dynamic> body, {required Map<String, dynamic> defaultFields}) {
  defaultFields.forEach((key,value) {
    if (body[key] == null) {
      body[key] = value;
    }
  });
}

Map<String, dynamic> extractFromBody(Map<String, dynamic> body, {required List<String> fields}) {
  final extracted = <String, dynamic>{};
  for (var field in fields) {
    if(body[field] != null) {
      extracted[field] = body[field];
      body.remove(field);
    }
  }
  return extracted;
}

Map<String, Map<String, dynamic>> splitBody(Map<String, dynamic> body, {required String mediaType}) {
  final result = <String, Map<String, dynamic>>{};

  // Extract body for media
  result['mediaBody'] = extractFromBody(body, fields: 
    [
      'originalname',
      'description',
      'releasedate',
      'criticscore',
      'communityscore',
      'mediatype',
    ]
  );

  // Extract body for mediaUser
  result['mediauserBody'] = extractFromBody(body, fields:
    [
      'coverimage',
      'icon',
      'backgroundimage',
    ]
  );
  result['mediauserBody']?['name']=result['mediaBody']?['originalname'];

  // Extract body for creators
  result['creatorsBody'] = extractFromBody(body, fields: 
    [
      'creators',
    ]
  );

  // Extract body for publishers
  result['publishersBody'] = extractFromBody(body, fields: 
    [
      'publishers',
    ]
  );
  
  // Extract body for platforms
  result['platformsBody'] = extractFromBody(body, fields: 
    [
      'platforms',
    ]
  );

  // Extract body for links
  result['linksBody'] = extractFromBody(body, fields: 
    [
      'links',
    ]
  );

  // Extract body for series
  result['seriesBody'] = extractFromBody(body, fields: 
    [
      'series_name',
    ]
  );

  // Extract body for mediaSeries
  result['mediaseriesBody'] = extractFromBody(body, fields:
    [
      'series',
    ]
  );

  // Extract body for genres
  result['genresBody'] = extractFromBody(body, fields:
    [
      'genres',
    ]
  );

  // The remaining body is for the mediaType
  result['${mediaType}Body'] = body;

  return result;
}

Future<Map<String,dynamic>> postRequestWithAxios (
  Map<String, dynamic> body,
  String table,
  final axios
) async {
  http.Response response = await axios.post('/$table', body, headers: {'Content-Type': 'application/json'});
  if (response.statusCode < 200 || response.statusCode > 299) {
    throw Exception('Failed to create for table $table: ${response.statusCode}');
  }
  return json.decode(response.body);
}

Future<Map<String,dynamic>> getByNameRequestWithAxios (
  String table,
  String name,
  final axios
) async {
  http.Response response = await axios.get('/$table/name?query=$name');
  if (response.statusCode < 200 || response.statusCode > 299) {
    throw Exception('Failed to get by name $name from table $table: ${response.statusCode}');
  }
  return json.decode(response.body);
}

Future<Map<String, dynamic>> createFromBody(Map<String, Map<String, dynamic>> body, {required String mediaType}) async {
  final axios = Config().axios;
  final _supabase = SupabaseClientSingleton.client;
  Map<String, dynamic> result = <String, dynamic>{};

  Future<Map<String, dynamic>> postRequest(body, table) async => await postRequestWithAxios(body, table, axios);
  Future<Map<String, dynamic>> getByNameRequest(table, name) async => await getByNameRequestWithAxios(table, name, axios);

  // Create media from body
  result['media'] = await postRequest(body['mediaBody']!, 'medias');

  // Create mediaType from body
  body['${mediaType}Body']?['mediaid'] = result['media']?['id'];
  result[mediaType] = await _supabase
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

Future<void> validateExistence(dynamic id, String table, dynamic _supabase) async {
  try {
    await _supabase
      .from(table)
      .select()
      .eq('id', id)
      .single();
  }
  catch (e) {
    throw Exception('${table.toLowerCase()}Id not found');
  }
}

void validateService(String service) {
  final List<String> validServices = [
    'pcgamingwiki',
    'howlongtobeat',
    'steam',
    'goodreads',
    'tmdbmovie',
    'tmdbseries',
    'anilistanime',
    'anilistmanga',
    'igdb'
  ];
  if (!validServices.contains(service.toLowerCase())) {
    throw Exception('Service not found');
  }
}

void validateMethod(String method) {
  final List<String> validMethods = [
    'options',
    'info',
    'recommendations'
  ];
  if (!validMethods.contains(method.toLowerCase())) {
    throw Exception('Method not found');
  }
}