import 'package:flutter/material.dart';
import '../Models/anime.dart';
import '../Models/book.dart';
import '../Models/game.dart';
import '../Models/manga.dart';
import '../Models/movie.dart';
import '../Models/tv_series.dart';
import '../Models/general/media_type.dart';
import '../Services/anime_service.dart';
import '../Services/book_service.dart';
import '../Services/game_service.dart';
import '../Services/manga_service.dart';
import '../Services/movie_service.dart';
import '../Services/provider_service.dart';
import '../Services/wishlist_service.dart';
import '../Services/tv_series_service.dart';
import '../Services/media_user_service.dart';

dynamic getForType(Type type, String request) {
  Map<Type, dynamic> info = {
    Anime : {
      'serviceInstance'  : AnimeService.instance,
      'icon'             : Icon(Icons.movie),
      'dbName'           : 'anime',
      'dbNamePlural'     : 'anime',
      'dbNameCapitalize' : 'Anime',
      'attribute'        : 'anilistid',
      'oldAttribute'     : 'id',
      'options'          : getOptionsAnime,
      'info'             : getInfoAnime,
      'recs'             : getRecsAnime,
    },
    Book : {
      'serviceInstance'  : BookService.instance,
      'icon'             : Icon(Icons.book),
      'dbName'           : 'book',
      'dbNamePlural'     : 'books',
      'dbNameCapitalize' : 'Book',
      'attribute'        : 'goodreadslink',
      'oldAttribute'     : 'link',
      'options'          : getOptionsBook,
      'info'             : getInfoBook,
      'recs'             : getRecsBook,
    },
    Game : {
      'serviceInstance'  : GameService.instance,
      'icon'             : Icon(Icons.videogame_asset),
      'dbName'           : 'game',
      'dbNamePlural'     : 'games',
      'dbNameCapitalize' : 'Game',
      'attribute'        : 'igdbid',
      'oldAttribute'     : 'id',
      'options'          : getOptionsIGDB,
      'info'             : getInfoIGDB,
      'recs'             : getRecsIGDB,
    },
    Manga : {
      'serviceInstance'  : MangaService.instance,
      'icon'             : Icon(Icons.auto_stories),
      'dbName'           : 'manga',
      'dbNamePlural'     : 'manga',
      'dbNameCapitalize' : 'Manga',
      'attribute'        : 'anilistid',
      'oldAttribute'     : 'id',
      'options'          : getOptionsManga,
      'info'             : getInfoManga,
      'recs'             : getRecsManga,
    },
    Movie : {
      'serviceInstance'  : MovieService.instance,
      'icon'             : Icon(Icons.local_movies),
      'dbName'           : 'movie',
      'dbNamePlural'     : 'movies',
      'dbNameCapitalize' : 'Movie',
      'attribute'        : 'tmdbid',
      'oldAttribute'     : 'id',
      'options'          : getOptionsMovie,
      'info'             : getInfoMovie,
      'recs'             : getRecsMovie,
    },
    TVSeries : {
      'serviceInstance'  : TVSeriesService.instance,
      'icon'             : Icon(Icons.tv),
      'dbName'           : 'tv_series',
      'dbNamePlural'     : 'tv_series',
      'dbNameCapitalize' : 'TV Series',
      'attribute'        : 'tmdbid',
      'oldAttribute'     : 'id',
      'options'          : getOptionsSeries,
      'info'             : getInfoSeries,
      'recs'             : getRecsSeries,
    },
  };

  if (info.containsKey(type) && info[type].containsKey(request)) {
    return info[type][request];
  }
  throw UnimplementedError('GetForType with type $type and request $request is not implemented!');
}

dynamic getServiceInstanceForType(Type type) {
  return getForType(type, 'serviceInstance');
}

dynamic getIconForType(Type type) {
  return getForType(type, 'icon');
}

String getMediaTypeDbName(Type type) {
  return getForType(type, 'dbName');
}

String getMediaTypeDbNamePlural(Type type) {
  return getForType(type, 'dbNamePlural');
}

String getMediaTypeDbNameCapitalize(Type type) {
  return getForType(type, 'dbNameCapitalize');
}

String getAttributeNameForType(Type type) {
  return getForType(type, 'attribute');
}

String getOldAttributeNameForType(Type type) {
  return getForType(type, 'oldAttribute');
}

dynamic getOptionsForType(Type type, String query) async {
  return getForType(type, 'options')(query);
}

dynamic getInfoForType(Type type, Map<String, dynamic> query) async {
  return getForType(type, 'info')(query);
}

dynamic getRecsForType(Type type, Map<String, dynamic> query) async {
  return getForType(type, 'recs')(query);
}

List<MediaType> getAllFromService(Type type, String serviceType) {
  Set<int> ids = {};

  if (serviceType == 'MediaUser') {
    ids = MediaUserService
      .instance
      .items
      .map((entry) => entry.mediaId)
      .toSet();
  }
  else if(serviceType == 'Wishlist') {
    ids = WishlistService
      .instance
      .items
      .map((entry) => entry.mediaId)
      .toSet();
  }
  else {
    throw UnimplementedError('GetFromService for serviceType $serviceType is not implemented!');
  }

  dynamic serviceInstance = getServiceInstanceForType(type);
  return serviceInstance
    .items
    .where((mt) => ids.contains(mt.mediaId))
    .toList();
}