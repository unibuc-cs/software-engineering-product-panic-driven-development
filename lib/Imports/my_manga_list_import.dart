import '../Models/manga.dart';
import '../Services/provider_service.dart';
import 'provider_import.dart';

ProviderImport<Manga> get myMangaListImport => ProviderImport<Manga>(
  listProvider: getMangaList,
  optionsProvider: getOptionsManga,
  providerName: 'MyAnimeList',
  howToGetIdLink: 'https://letmegooglethat.com/?q=how+to+remember+my+myanimelist+username',
);
