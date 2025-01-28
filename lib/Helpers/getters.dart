import 'package:flutter/material.dart';
import 'package:mediamaster/Imports/goodreads_import.dart';
import 'package:mediamaster/Imports/my_anime_list_import.dart';
import 'package:mediamaster/Imports/my_manga_list_import.dart';
import 'package:mediamaster/Imports/provider_import.dart';
import 'package:mediamaster/Imports/steam_import.dart';
import 'package:mediamaster/Imports/trakt_movies_import.dart';
import 'package:mediamaster/Imports/trakt_series_import.dart';
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
      'serviceInstance'     : AnimeService.instance,
      'icon'                : Icon(Icons.movie),
      'dbName'              : 'anime',
      'dbNamePlural'        : 'anime',
      'dbNameCapitalize'    : 'Anime',
      'attribute'           : 'anilistid',
      'oldAttribute'        : 'id',
      'measureUnit'         : 'episodes',
      'measureAttributeName': 'nrepisodesseen',
      'defaultStatus'       : 'Plan to watch',
      'statusOptions'       : ['Plan to watch', 'Watching', 'Completed'],
      'options'             : getOptionsAnime,
      'info'                : getInfoAnime,
      'recs'                : getRecsAnime,
      'importer'            : myAnimeListImport,
    },
    Book : {
      'serviceInstance'     : BookService.instance,
      'icon'                : Icon(Icons.book),
      'dbName'              : 'book',
      'dbNamePlural'        : 'books',
      'dbNameCapitalize'    : 'Book',
      'attribute'           : 'goodreadslink',
      'oldAttribute'        : 'link',
      'measureUnit'         : 'pages',
      'measureAttributeName': 'bookreadpages',
      'defaultStatus'       : 'Plan to read',
      'statusOptions'       : ['Plan to read', 'Reading', 'Completed'],
      'options'             : getOptionsBook,
      'info'                : getInfoBook,
      'recs'                : getRecsBook,
      'importer'            : goodreadsImport,
    },
    Game : {
      'serviceInstance'     : GameService.instance,
      'icon'                : Icon(Icons.videogame_asset),
      'dbName'              : 'game',
      'dbNamePlural'        : 'games',
      'dbNameCapitalize'    : 'Game',
      'attribute'           : 'igdbid',
      'oldAttribute'        : 'id',
      'measureUnit'         : 'hours',
      'measureAttributeName': 'gametime',
      'defaultStatus'       : 'Plan to play',
      'statusOptions'       : ['Plan to play', 'Playing', 'Completed'],
      'options'             : getOptionsIGDB,
      'info'                : getInfoIGDB,
      'recs'                : getRecsIGDB,
      'importer'            : steamImport,
    },
    Manga : {
      'serviceInstance'     : MangaService.instance,
      'icon'                : Icon(Icons.auto_stories),
      'dbName'              : 'manga',
      'dbNamePlural'        : 'manga',
      'dbNameCapitalize'    : 'Manga',
      'attribute'           : 'anilistid',
      'oldAttribute'        : 'id',
      'measureUnit'         : 'chapters',
      'measureAttributeName': 'mangareadchapters',
      'defaultStatus'       : 'Plan to read',
      'statusOptions'       : ['Plan to read', 'Reading', 'Completed'],
      'options'             : getOptionsManga,
      'info'                : getInfoManga,
      'recs'                : getRecsManga,
      'importer'            : myMangaListImport,
    },
    Movie : {
      'serviceInstance'     : MovieService.instance,
      'icon'                : Icon(Icons.local_movies),
      'dbName'              : 'movie',
      'dbNamePlural'        : 'movies',
      'dbNameCapitalize'    : 'Movie',
      'attribute'           : 'tmdbid',
      'oldAttribute'        : 'id',
      'measureUnit'         : 'seconds',
      'measureAttributeName': 'moviesecondswatched',
      'defaultStatus'       : 'Plan to watch',
      'statusOptions'       : ['Plan to watch', 'Watching', 'Completed'],
      'options'             : getOptionsMovie,
      'info'                : getInfoMovie,
      'recs'                : getRecsMovie,
      'importer'            : traktMoviesImport,
    },
    TVSeries : {
      'serviceInstance'     : TVSeriesService.instance,
      'icon'                : Icon(Icons.tv),
      'dbName'              : 'tv_series',
      'dbNamePlural'        : 'tv_series',
      'dbNameCapitalize'    : 'TV Series',
      'attribute'           : 'tmdbid',
      'oldAttribute'        : 'id',
      'measureUnit'         : 'episodes',
      'measureAttributeName': 'nrepisodesseen',
      'defaultStatus'       : 'Plan to watch',
      'statusOptions'       : ['Plan to watch', 'Watching', 'Completed'],
      'options'             : getOptionsSeries,
      'info'                : getInfoSeries,
      'recs'                : getRecsSeries,
      'importer'            : traktSeriesImport,
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

String getMeasureUnitForType(Type type) {
  return getForType(type, 'measureUnit');
}

String getMeasureAttributeNameForType(Type type) {
  return getForType(type, 'measureAttributeName');
}

String getDefaultStatusForType(Type type) {
  return getForType(type, 'defaultStatus');
}

List<String> getStatusOptionsForType(Type type) {
  return getForType(type, 'statusOptions');
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

ProviderImport getImporterForType(Type type) {
  return getForType(type, 'importer');
}
