import 'config.dart';
import 'package:supabase/supabase.dart';

class SupabaseClientSingleton {
  static final SupabaseClient _client = SupabaseClient(
    Config().supabaseUrl,
    Config().supabaseKey,
  );

  static SupabaseClient get client => _client;
}
