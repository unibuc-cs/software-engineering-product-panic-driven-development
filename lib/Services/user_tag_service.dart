import '../Models/user_tag.dart';
import 'general/service.dart';

class UserTagService extends Service<UserTag> {
  UserTagService._() : super(UserTag.endpoint, UserTag.from);
  
  static final UserTagService _instance = UserTagService._();

  static UserTagService get instance => _instance;
}
