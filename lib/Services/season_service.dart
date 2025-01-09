import 'general/service.dart';
import '../Models/season.dart';

class SeasonService extends Service<Season> {
  SeasonService() : super(Season.endpoint, Season.from);
}
