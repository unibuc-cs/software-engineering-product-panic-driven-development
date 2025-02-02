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

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await getRequest<List<dynamic>>(
      endpoint: '$endpoint/users',
      fromJson: (json) => json as List<dynamic>,
    );

    return response.map((user) => Map<String, dynamic>.from(user)).toList();
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final response = await getRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/users/$userId', 
      fromJson: (json) => Map<String, dynamic>.from(json),
    );
    return response;
  }

  Future<Map<String, dynamic>> updateUserProfile(String name, String photoUrl) async {
    final response = await postRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/updateUser',  
      body: {
        'name': name,
        'photoUrl': photoUrl,
      },
      fromJson: (json) => Map<String, dynamic>.from(json),
    );

    print('User profile updated successfully');
      return response;  
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

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    bool isGuest = false,
    String? photoUrl,
  }) {
    return postRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/signup',
      body: {
        'email': email,
        'password': password,
        'name': name,
        'isGuest': isGuest,
        'photoUrl': photoUrl,
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
