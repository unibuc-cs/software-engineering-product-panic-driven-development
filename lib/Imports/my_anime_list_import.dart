import '../Models/anime.dart';
import '../Services/provider_service.dart';
import 'provider_import.dart';

ProviderImport<Anime> get myAnimeListImport => ProviderImport<Anime>(
  listProvider            : getAnimeList,
  optionsProvider         : getOptionsAnime,
  optionsMillisecondsDelay: 2200,
  importMillisecondsDelay : 2200,
  providerName            : 'MyAnimeList',
  howToGetIdLink          : 'https://letmegooglethat.com/?q=how+to+remember+my+myanimelist+username',
  idName                  : 'username',
);
