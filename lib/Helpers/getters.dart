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
import '../Services/wishlist_service.dart';
import '../Services/tv_series_service.dart';
import '../Services/media_user_service.dart';

dynamic getServiceInstanceForType(Type type) {
  if (type == Game) {
    return GameService.instance;
  }
  if (type == Book) {
    return BookService.instance;
  }
  if (type == Anime) {
    return AnimeService.instance;
  }
  if (type == Manga) {
    return MangaService.instance;
  }
  if (type == Movie) {
    return MovieService.instance;
  }
  if (type == TVSeries) {
    return TVSeriesService.instance;
  }
  throw UnimplementedError('GetServiceForType of type $type is not implemented!');
}

dynamic getIconForType(Type type) {
  if (type == Game) {
    return Icon(Icons.videogame_asset);
  }
  else if (type == Book) {
    return Icon(Icons.book);
  }
  else if (type == Anime) {
    return Icon(Icons.movie);
  }
  else if (type == Manga) {
    return Icon(Icons.auto_stories);
  }
  else if (type == Movie) {
    return Icon(Icons.local_movies);
  }
  else if (type == TVSeries) {
    return Icon(Icons.tv);
  }
  else {
    throw UnimplementedError('Leading Icon for media type $type not declared.');
  }
}

String getMediaTypeDbName(Type type) {
  if (type == Game) {
    return 'game';
  }
  if (type == Book) {
    return 'book';
  }
  if (type == Anime) {
    return 'anime';
  }
  if (type == Manga) {
    return 'manga';
  }
  if (type == Movie) {
    return 'movie';
  }
  if (type == TVSeries) {
    return 'tv_series';
  }
  throw UnimplementedError('Media type db name for $type is not implemented');
}

String getMediaTypeDbNameCapitalize(Type type) {
  if (type == Game) {
    return 'Game';
  }
  if (type == Book) {
    return 'Book';
  }
  if (type == Anime) {
    return 'Anime';
  }
  if (type == Manga) {
    return 'Manga';
  }
  if (type == Movie) {
    return 'Movie';
  }
  if (type == TVSeries) {
    return 'TV Series';
  }
  throw UnimplementedError('Media type db name CAPITALIZE for $type is not implemented');
}

String getMediaTypeDbNamePlural(Type type) {
  if (type == Game) {
    return 'games';
  }
  if (type == Book) {
    return 'books';
  }
  if (type == Anime) {
    return 'anime';
  }
  if (type == Manga) {
    return 'manga';
  }
  if (type == Movie) {
    return 'movies';
  }
  if (type == TVSeries) {
    return 'tv_series';
  }
  throw UnimplementedError('Media type db name PLURAL for $type is not implemented');
}

List<MediaType> getFromService(Type type, String serviceType) {
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

  dynamic service;

  if (type == Game) {
    service = GameService.instance;
  }
  else if (type == Book) {
    service = BookService.instance;
  }
  else if (type == Anime) {
    service = AnimeService.instance;
  }
  else if (type == Manga) {
    service = MangaService.instance;
  }
  else if (type == Movie) {
    service = MovieService.instance;
  }
  else if (type == TVSeries) {
    service = TVSeriesService.instance;
  }
  else {
    throw UnimplementedError('GetFromService of type $type is not implemented!');
  }

  return service
    .items
    .where((mt) => ids.contains(mt.mediaId))
    .toList();
}