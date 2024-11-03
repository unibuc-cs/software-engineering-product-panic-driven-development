import 'ServiceHandler.dart';
import '../books/AnilistManga.dart';
import '../books/GoodReads.dart';
import '../games/HowLongToBeat.dart';
import '../games/IGDB.dart';
import '../games/PcGamingWiki.dart';
import '../movies/TmdbMovies.dart';
import '../tv_series/AnilistAnime.dart';
import '../tv_series/TmdbSeries.dart';

class ServiceBuilder {
  static void setAnilistManga() {
    ServiceHandler.setService(AnilistManga.instance);
    ServiceHandler.setKey("id");
  }

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

  static void setTmdbMovies() {
    ServiceHandler.setService(TmdbMovies.instance);
    ServiceHandler.setKey("id");
  }

  static void setAnilistAnime() {
    ServiceHandler.setService(AnilistAnime.instance);
    ServiceHandler.setKey("id");
  }

  static void setTmdbSeries() {
    ServiceHandler.setService(TmdbSeries.instance);
    ServiceHandler.setKey("id");
  }
}
