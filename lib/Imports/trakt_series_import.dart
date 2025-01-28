import '../Models/tv_series.dart';
import '../Services/provider_service.dart';
import 'provider_import.dart';

ProviderImport<TVSeries> get traktSeriesImport => ProviderImport<TVSeries>(
  listProvider: getSeriesList,
  optionsProvider: getOptionsSeries,
  providerName: 'Trakt',
  howToGetIdLink: 'https://trakt.tv/users/me',
  libraryName: 'watchlist',
);
