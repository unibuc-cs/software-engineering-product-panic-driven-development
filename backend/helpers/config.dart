import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:axios_package/axios_package.dart';

class Config {
  final _dotenv = DotEnv();
  final baseUrl = const bool.fromEnvironment('LOCAL', defaultValue: false)
    ? 'http://localhost:3007/api'
    : 'https://mediamaster.fly.dev/api';

  Config() {
    _loadEnvFile();
  }

  void _loadEnvFile() {
    final envFile = File('.env');
    if (envFile.existsSync()) {
      _dotenv.load();
    }
  }

  Axios get axios => Axios(baseUrl: baseUrl);

  String? getEnv(String key) {
    return _dotenv[key] ?? Platform.environment[key];
  }

  String get igdbId {
    return getEnv('CLIENT_ID_IGDB') ?? '';
  }

  String get igdbSecret {
    return getEnv('CLIENT_SECRET_IGDB') ?? '';
  }

  String get goodreadsAgents {
    return getEnv('USER_AGENTS_GOODREADS') ?? '';
  }

  String get tmdbToken {
    return getEnv('ACCESS_TOKEN_TMDB') ?? '';
  }

  String get supabaseUrl {
    return getEnv('URL_SUPABASE') ?? '';
  }

  String get supabaseKey {
    return getEnv('ANON_KEY_SUPABASE') ?? '';
  }

  String get supabaseServiceKey {
    return getEnv('SERVICE_KEY_SUPABASE') ?? '';
  }

  String get steamKey {
    return getEnv('API_KEY_STEAM') ?? '';
  }

  int get port {
    return int.parse(getEnv('PORT') ?? '8080');
  }
}
