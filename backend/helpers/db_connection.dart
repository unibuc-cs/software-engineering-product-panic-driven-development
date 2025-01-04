import 'config.dart';
import 'package:supabase/supabase.dart';

class SupabaseClientSingleton {
  static final SupabaseClient _client = SupabaseClient(
    Config().supabaseUrl,
    Config().supabaseServiceKey,
  );

  static SupabaseClient get client => _client;
  static String? get userId => _client.auth.currentUser?.id;
}
