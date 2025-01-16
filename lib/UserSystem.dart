import 'Helpers/database.dart';
import 'Services/auth_service.dart';

class UserSystem {
  // The following 3 definitions are used to make this class a singleton
  UserSystem._();
  
  static final UserSystem _instance = UserSystem._();

  static UserSystem get instance => _instance;
  // Until now we made the class a singleton. Next is what really matters

  Map<String, dynamic>? currentUserData;
  // late final authService;

  void init() {
    // authService = AuthService.instance;
  }

  Future<void> login() async {
    Map<String, dynamic> userData = await AuthService.instance.details();

    while (userData.isEmpty) {
      userData = await AuthService.instance.details();
    }

    currentUserData = Map<String, dynamic>();
    currentUserData!['id'] = userData['id'];
    currentUserData!['name'] = userData['user_metadata']?['name'];
    await HydrateWithUser();
  }

  Future<void> logout() async {
    await AuthService.instance.logout();
    currentUserData = null;
    UnhydrateWithUser();
  }

  String getCurrentUserId() {
    if (currentUserData != null) {
      return currentUserData!['id'];
    }
    return '';
  }
}
