import '../Models/movie.dart';
import '../Services/provider_service.dart';
import 'provider_import.dart';

ProviderImport<Movie> get traktMoviesImport => ProviderImport<Movie>(
  listProvider: getMoviesList,
  optionsProvider: getOptionsMovie,
  providerName: 'Trakt',
  howToGetIdLink: 'https://trakt.tv/users/me',
  libraryName: 'watchlist',
);
