import 'config.dart';
import 'package:supabase/supabase.dart';

class SupabaseClientSingleton {
  static SupabaseClient _client = SupabaseClient(
    Config().supabaseUrl,
    Config().supabaseServiceKey,
  );

  static SupabaseClient get client => _client;

  static void resetClient() {
    _client = SupabaseClient(
      Config().supabaseUrl,
      Config().supabaseServiceKey,
    );
  }
}
