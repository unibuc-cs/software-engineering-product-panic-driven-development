import '../Models/anime.dart';
import '../Services/provider_service.dart';
import 'provider_import.dart';

ProviderImport<Anime> get myAnimeListImport => ProviderImport<Anime>(
  listProvider: getAnimeList,
  optionsProvider: getOptionsAnime,
  millisecondsDelay: 2000,
  importMillisecondsDelay: 10000,
  providerName: 'MyAnimeList',
  howToGetIdLink: 'https://letmegooglethat.com/?q=how+to+remember+my+myanimelist+username',
);
