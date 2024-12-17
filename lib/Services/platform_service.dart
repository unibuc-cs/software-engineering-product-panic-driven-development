import 'general/request.dart';
import 'general/service.dart';
import '../Models/platform.dart';

class PlatformService extends Service<Platform> {
  PlatformService()
      : super(
          resource: 'platforms',
          fromJson: (json) => Platform.from(json),
          toJson  : (platform) => platform.toSupa(),
        );
  
  Future<Platform> readByName(String name) async {
    return await request<Platform>(
      method: 'GET',
      endpoint: '/platforms/name?query=$name',
      fromJson: fromJson,
    );
  }
}
