import 'general/request.dart';

class UserService {
  final String endpoint = '/users';

  UserService._() {}

  static final UserService _instance = UserService._();

  static UserService get instance => _instance;

  Future<List<Map<String, dynamic>>> readAll() async {
    return getRequest<List<Map<String, dynamic>>>(
      endpoint: '$endpoint',
      fromJson: (_) => (_ as List).cast<Map<String, dynamic>>(),
    );
  }

  Future<Map<String, dynamic>> read(String userId) async {
    return getRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/$userId',
      fromJson: (_) => _,
    );
  }

  Future<Map<String, dynamic>> update(Map<String, dynamic> body) async {
    return postRequest<Map<String, dynamic>>(
      endpoint: '$endpoint/update',
      body    : body,
      fromJson: (_) => _,
    );
  }
}
