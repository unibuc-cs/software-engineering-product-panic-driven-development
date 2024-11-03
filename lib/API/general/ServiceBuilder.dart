import 'ServiceHandler.dart';
import '../books/GoodReads.dart';
import '../games/HowLongToBeat.dart';
import '../games/IGDB.dart';
import '../games/PcGamingWiki.dart';
import '../streaming/Anilist.dart';
import '../streaming/Tmdb.dart';

class ServiceBuilder {
  static void setGoodReads() {
    ServiceHandler.setService(GoodReads.instance);
    ServiceHandler.setKey("link");
  }

  static void setHowLongToBeat() {
    ServiceHandler.setService(HowLongToBeat.instance);
    ServiceHandler.setKey("link");
  }

  static void setIgdb() {
    ServiceHandler.setService(IGDB.instance);
    ServiceHandler.setKey("id");
  }

  static void setPcGamingWiki() {
    ServiceHandler.setService(PcGamingWiki.instance);
    ServiceHandler.setKey("name");
  }

  static void setAnilistManga() {
    Anilist.instance.setManga();
    ServiceHandler.setService(Anilist.instance);
    ServiceHandler.setKey("id");
  }

  static void setAnilistAnime() {
    Anilist.instance.setAnime();
    ServiceHandler.setService(Anilist.instance);
    ServiceHandler.setKey("id");
  }

  static void setTmdbMovies() {
    Tmdb.instance.setMovies();
    ServiceHandler.setService(Tmdb.instance);
    ServiceHandler.setKey("id");
  }

  static void setTmdbSeries() {
    Tmdb.instance.setSeries();
    ServiceHandler.setService(Tmdb.instance);
    ServiceHandler.setKey("id");
  }
}
