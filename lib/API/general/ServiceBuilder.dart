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
  }

  static void setGoodReads() {
    ServiceHandler.setService(GoodReads.instance);
  }

  static void setHowLongToBeat() {
    ServiceHandler.setService(HowLongToBeat.instance);
  }

  static void setIgdb() {
    ServiceHandler.setService(IGDB.instance);
  }

  static void setPcGamingWiki() {
    ServiceHandler.setService(PcGamingWiki.instance);
  }

  static void setTmdbMovies() {
    ServiceHandler.setService(TmdbMovies.instance);
  }

  static void setAnilistAnime() {
    ServiceHandler.setService(AnilistAnime.instance);
  }

  static void setTmdbSeries() {
    ServiceHandler.setService(TmdbSeries.instance);
  }
}
