import 'package:axios_package/axios_package.dart';

final baseUrl = const bool.fromEnvironment('LOCAL', defaultValue: false)
  ? 'http://localhost:3007/api'
  : 'https://mediamaster.fly.dev/api';

Axios get axios => Axios(baseUrl: baseUrl);
