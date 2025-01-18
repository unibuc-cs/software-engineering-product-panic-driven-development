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
    },
    Book : {
      'serviceInstance'  : BookService.instance,
      'icon'             : Icon(Icons.book),
      'dbName'           : 'book',
      'dbNamePlural'     : 'books',
      'dbNameCapitalize' : 'Book',
    },
    Game : {
      'serviceInstance'  : GameService.instance,
      'icon'             : Icon(Icons.videogame_asset),
      'dbName'           : 'game',
      'dbNamePlural'     : 'games',
      'dbNameCapitalize' : 'Game',
    },
    Manga : {
      'serviceInstance'  : MangaService.instance,
      'icon'             : Icon(Icons.auto_stories),
      'dbName'           : 'manga',
      'dbNamePlural'     : 'manga',
      'dbNameCapitalize' : 'Manga',
    },
    Movie : {
      'serviceInstance'  : MovieService.instance,
      'icon'             : Icon(Icons.local_movies),
      'dbName'           : 'movie',
      'dbNamePlural'     : 'movies',
      'dbNameCapitalize' : 'Movie',
    },
    TVSeries : {
      'serviceInstance'  : TVSeriesService.instance,
      'icon'             : Icon(Icons.tv),
      'dbName'           : 'tv_series',
      'dbNamePlural'     : 'tv_series',
      'dbNameCapitalize' : 'TV Series',
    },
  };

  if (info.containsKey(type) && info[type].containsKey(request)) {
    return info[type][request];
  }
  throw UnimplementedError('GetForType with request $request is not implemented!');
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

dynamic getOptions(Type type, String query) async {
  if (type == Anime) {
    return await getOptionsAnime(query);
  }
  if (type == Book) {
    return await getOptionsBook(query);
  }
  if (type == Game) {
    return await getOptionsIGDB(query);
  }
  if (type == Manga) {
    return await getOptionsManga(query);
  }
  if (type == Movie) {
    return await getOptionsMovie(query);
  }
  if (type == TVSeries) {
    return await getOptionsSeries(query);
  }
  throw UnimplementedError('GetOptions with for type $type is not implemented!');
  //TODO: return getForType(type, 'options');
}

dynamic getInfo(Type type, Map<String, dynamic> query) async {
  if (type == Anime) {
    return await getInfoAnime(query);
  }
  if (type == Book) {
    return await getInfoBook(query);
  }
  if (type == Manga) {
    return await getInfoManga(query);
  }
  if (type == Movie) {
    return await getInfoMovie(query);
  }
  if (type == TVSeries) {
    return await getInfoSeries(query);
  }
  throw UnimplementedError('GetOptions with for type $type is not implemented!');
  //TODO: return getForType(type, 'info');
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