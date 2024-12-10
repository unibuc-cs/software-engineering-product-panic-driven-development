import 'config.dart';
import 'package:supabase/supabase.dart';

class SupabaseClientSingleton {
  static final SupabaseClient _client = SupabaseClient(
    Config().supabase_url, 
    Config().supabase_key,                      
  );

  static SupabaseClient get client => _client;
}