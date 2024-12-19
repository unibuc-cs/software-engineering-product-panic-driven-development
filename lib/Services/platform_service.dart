import 'general/service.dart';
import '../Models/platform.dart';

class PlatformService extends Service<Platform> {
  PlatformService() : super(Platform.endpoint, Platform.from);
}
