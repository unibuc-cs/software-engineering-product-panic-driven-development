import '../Models/game.dart';
import '../Services/provider_service.dart';
import 'provider_import.dart';

ProviderImport<Game> get steamImport => ProviderImport<Game>(
  listProvider: getGamesList,
  optionsProvider: getOptionsIGDB,
  milisecondsDelay: 300,
  customizations: (game) => {'icon': game['icon']},
  providerName: 'Steam',
  howToGetIdLink: 'https://www.howtogeek.com/819859/how-to-find-steam-id/#view-your-id-in-the-steam-app',
);
