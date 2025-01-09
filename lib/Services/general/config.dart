import 'package:axios_package/axios_package.dart';

class Config {
  Config._();

  static final Config _instance = Config._();

  static Config get instance => _instance;

  final String _baseUrl = const bool.fromEnvironment('LOCAL', defaultValue: false)
      ? 'http://localhost:3007/api'
      : 'https://mediamaster.fly.dev/api';

  late final Axios _axios = Axios(baseUrl: _baseUrl);

  String _token = '';

  Axios get axios => _axios;

  String get token => _token;
  set token(String token) => _token = token;
}
