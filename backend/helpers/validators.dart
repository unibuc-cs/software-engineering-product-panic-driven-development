import 'db.dart';

Future<void> validateExistence(dynamic id, String table) async {
  try {
    await SupabaseManager
      .client
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
    'igdb'
    'steam',
    'goodreads',
    'tmdbmovie',
    'tmdbseries',
    'myanimelist',
    'mymangalist',
    'pcgamingwiki',
    'anilistanime',
    'anilistmanga',
    'howlongtobeat',
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
