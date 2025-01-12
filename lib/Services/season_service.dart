import 'general/service.dart';
import '../Models/season.dart';

class SeasonService extends Service<Season> {
  SeasonService._() : super(Season.endpoint, Season.from);
  
  static final SeasonService _instance = SeasonService._();

  static SeasonService get instance => _instance;
}
