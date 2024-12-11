import 'utils.dart';

void validateBody(Map<String, dynamic> body, {List<String> fields = const []}) {
  if (body["id"] != null) {
    throw Exception('The body shouldn\'t contain an id field');
  }
  for (var field in fields) {
    if (body[field] == null) {
      throw Exception('${capitalize(field)} is required');
    }
    else if (body[field].runtimeType == String && body[field] == "") {
      throw Exception('${capitalize(field)} cannot be empty');
    }
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