import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:axios_package/axios_package.dart';

class Config {
  final DotEnv _dotenv = DotEnv();
  late final String _baseUrl;

  Config._() {
    _baseUrl = const bool.fromEnvironment('LOCAL', defaultValue: false)
      ? 'http://localhost:3007/api'
      : 'https://mediamaster.fly.dev/api';
    _loadEnvFile();
  }

  static final Config _instance = Config._();

  static Config get instance => _instance;

  void _loadEnvFile() {
    final envFile = File('.env');
    if (envFile.existsSync()) {
      _dotenv.load();
    }
  }

  String getEnv(String key, [String fallback = '']) => _dotenv[key] ?? Platform.environment[key] ?? fallback;

  Axios get axios => Axios(baseUrl: _baseUrl);

  String get igdbId => getEnv('CLIENT_ID_IGDB');

  String get igdbSecret => getEnv('CLIENT_SECRET_IGDB');

  String get goodreadsAgents => getEnv('USER_AGENTS_GOODREADS');

  String get tmdbToken => getEnv('ACCESS_TOKEN_TMDB');

  String get steamKey => getEnv('API_KEY_STEAM');

  String get secret => getEnv('SECRET');

  String get supabaseUrl => getEnv('URL_SUPABASE');

  String get supabaseKey => getEnv('ANON_KEY_SUPABASE');

  String get supabaseServiceKey => getEnv('SERVICE_KEY_SUPABASE');

  int get port => int.parse(getEnv('PORT', '8080'));
}
