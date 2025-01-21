import 'package:supabase/supabase.dart';
import 'db_connection.dart';

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
