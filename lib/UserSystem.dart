import 'package:mediamaster/Helpers/database.dart';
import 'package:mediamaster/Services/anime_service.dart';
import 'package:mediamaster/Services/auth_service.dart';
import 'package:mediamaster/Services/book_service.dart';
import 'package:mediamaster/Services/game_service.dart';
import 'package:mediamaster/Services/manga_service.dart';
import 'package:mediamaster/Services/media_user_service.dart';
import 'package:mediamaster/Services/movie_service.dart';
import 'package:mediamaster/Services/tv_series_service.dart';

import 'Models/general/media_type.dart';
import 'Models/game.dart';

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
    final userData = await AuthService.instance.details();

    currentUserData = Map<String, dynamic>();
    currentUserData!['id'] = userData['id'];
    currentUserData!['name'] = userData['user_metadata']?['name'];
    await HydrateWithUser();
  }

  Future<void> logout() async {
    await AuthService.instance.logout();
    currentUserData = null;
    await UnhydrateWithUser();
  }

  int getCurrentUserId() {
    if (currentUserData != null) {
      return currentUserData!['id'];
    }
    return -1;
  }

  List<Game> getUserGames() {
    if (currentUserData == null) {
      return [];
    }

    dynamic userId = currentUserData!['id'];

    var ids = MediaUserService
      .instance
      .items
      .where((mu) => mu.userId == userId)
      .map((mu) => mu.mediaId)
      .toSet();

    return GameService
      .instance
      .items
      .where((game) => ids.contains(game.mediaId))
      .toList();
  }

  List<MediaType> getUserMedia(String type) {
    if (currentUserData == null) {
      return [];
    }

    dynamic userId = currentUserData!['id'];

    var ids = MediaUserService
      .instance
      .items
      .where((mu) => mu.userId == userId)
      .map((mu) => mu.mediaId)
      .toSet();

    dynamic service;

    if (type.toLowerCase() == 'game') {
      service = GameService.instance;
    }
    else if (type.toLowerCase() == 'book') {
      service = BookService.instance;
    }
    else if (type.toLowerCase() == 'anime') {
      service = AnimeService.instance;
    }
    else if (type.toLowerCase() == 'manga') {
      service = MangaService.instance;
    }
    else if (type.toLowerCase() == 'movie') {
      service = MovieService.instance;
    }
    else if (type.toLowerCase() == 'tvseries') {
      service = TVSeriesService.instance;
    }
    else {
      throw UnimplementedError('GetUserMedia of type $type is not implemented!');
    }

    return service
      .items
      .where((mt) => ids.contains(mt.mediaId))
      .toList();
  }
}
