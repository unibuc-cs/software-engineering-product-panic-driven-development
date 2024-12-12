import 'general/service.dart';
import '../Models/platform.dart';

class PlatformService extends Service<Platform> {
  PlatformService()
      : super(
          resource: 'platforms',
          fromJson: (json) => Platform.from(json),
          toJson  : (platform) => platform.toSupa(),
        );
}
