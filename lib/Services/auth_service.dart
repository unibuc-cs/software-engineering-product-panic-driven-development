import 'general/config.dart';
import 'general/request.dart';

class AuthService {
  final String endpoint = '/auth';
  
  AuthService._() {}
  
  static final AuthService _instance = AuthService._();

  static AuthService get instance => _instance;

  Future<Map<String, dynamic>> details() async {
    return getRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/details',
      fromJson: (_) => _,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    Config.instance.token = (await postRequest<String>(
      endpoint: '$endpoint/login',
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => json['token'],
    ))['token'];
  }

  Future<String> getGoogleLoginUrl() async {
    final response = await postRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/login-google',
      body: {},
      fromJson: (json) => json,
    );
    return response['authUrl'] as String;
  }

  Future<Map<String, dynamic>> handleGoogleCallback(String token) async {
    final response = await postRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/callback-google',
      body: {'token': token},
      fromJson: (json) => json,
    );
    Config.instance.token = response['token'];
    return response;
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    bool isGuest = false,
  }) {
    return postRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/signup',
      body: {
        'email': email,
        'password': password,
        'name': name,
        'isGuest': isGuest,
      },
      fromJson: (json) => json,
    );
  }

  Future<void> logout() {
    return getRequest<void>(
      endpoint: '$endpoint/logout',
      fromJson: (_) => null,
    );
  }
}
