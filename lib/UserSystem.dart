import 'package:mediamaster/Models/media_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa; // The 'as supa' is required because 2 different User exists
import 'Models/user.dart';
import 'Models/game.dart';

class UserSystem {
  // The following 3 definitions are used to make this class a singleton
  static final UserSystem _userSystem = UserSystem._internal();

  factory UserSystem() {
    return _userSystem;
  }

  // This is the constructor, which will need to be changed probably when we add AUTH
  UserSystem._internal() {
    init();
  }
  // Until now we made the class a singleton. Next is what really matters

  User? currentUser;

  void init() {
    currentUser = null;
  }

  void login(User user) {
    currentUser = user;
  }

  void logout() {
    currentUser = null;
  }

  int getCurrentUserId() {
    if (currentUser != null) {
      return currentUser!.id;
    }
    return -1;
  }

  Future<List<Game>> getUserGames() async {
    var ids = (await supa
                     .Supabase
                     .instance
                     .client
                     .from('media-user')
                     .select('mediaid')
                     .eq('userid', currentUser!.id)
                     ).map((x) => x['mediaid'])
                      .toList();

    return
      (await supa
        .Supabase
        .instance
        .client
        .from('game')
        .select()
        .inFilter('mediaid', ids)
        ).map(Game.from)
         .toList();
  }

  Future<List<MediaType>> getUserMedia(String type) async {
    if (type.toLowerCase()=='game') {
      return getUserGames();
    }

    throw UnimplementedError('Getter getUserMedia is not implemented for type $type');
  }
}
