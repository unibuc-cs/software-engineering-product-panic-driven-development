import 'general/service.dart';
import '../Models/platform.dart';

class PlatformService extends Service<Platform> {
  PlatformService._() : super(Platform.endpoint, Platform.from);
  
  static final PlatformService _instance = PlatformService._();

  static PlatformService get instance => _instance;
}
