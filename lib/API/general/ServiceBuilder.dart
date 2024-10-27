import 'ServiceHandler.dart';
import '../books/GoodReads.dart';
import '../games/HowLongToBeat.dart';
import '../games/IGDB.dart';
import '../games/PcGamingWiki.dart';
import '../movies/TmdbMovies.dart';
import '../tv_series/TmdbSeries.dart';

class ServiceBuilder {
  static Future<void> setGoodReads() {
    ServiceHandler.setService(GoodReads.instance);
    return Future.value();
  }

  static Future<void> setHowLongToBeat() {
    ServiceHandler.setService(HowLongToBeat.instance);
    return Future.value();
  }

  static Future<void> setIgdb() {
    ServiceHandler.setService(IGDB.instance);
    return Future.value();
  }

  static Future<void> setPcGamingWiki() {
    ServiceHandler.setService(PcGamingWiki.instance);
    return Future.value();
  }

  static Future<void> setTmdbMovies() {
    ServiceHandler.setService(TmdbMovies.instance);
    return Future.value();
  }

  static Future<void> setTmdbSeries() {
    ServiceHandler.setService(TmdbSeries.instance);
    return Future.value();
  }
}
