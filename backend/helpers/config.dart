import 'dart:io';
import 'package:dotenv/dotenv.dart';

class Config {
  final _dotenv = DotEnv();

  Config() {
    _loadEnvFile();
  }

  void _loadEnvFile() {
    final envFile = File('.env');
    if (envFile.existsSync()) {
      _dotenv.load();
    }
  }

  String? getEnv(String key) {
    return _dotenv[key] ?? Platform.environment[key];
  }

  String get igdb_id {
    return getEnv('CLIENT_ID_IGDB') ?? '';
  }

  String get igdb_secret {
    return getEnv('CLIENT_SECRET_IGDB') ?? '';
  }

  String get goodreads_agents {
    return getEnv('USER_AGENTS_GOODREADS') ?? '';
  }

  String get tmdb_token {
    return getEnv('ACCESS_TOKEN_TMDB') ?? '';
  }

  String get supabase_url {
    return getEnv('URL_SUPABASE') ?? '';
  }

  String get supabase_key {
    return getEnv('ANON_KEY_SUPABASE') ?? '';
  }

  String get steam_key {
    return getEnv('API_KEY_STEAM') ?? '';
  }

  int get port {
    return int.parse(getEnv('PORT') ?? '8080');
  }
}
