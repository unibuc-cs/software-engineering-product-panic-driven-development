import 'general/request.dart';
import 'general/service.dart';
import '../Models/creator.dart';

class CreatorService extends Service<Creator> {
  CreatorService()
      : super(
          resource: 'creators',
          fromJson: (json) => Creator.from(json),
          toJson  : (creator) => creator.toSupa(),
        );
  
  Future<Creator> readByName(String name) async {
    return await request<Creator>(
      method: 'GET',
      endpoint: '/creators/name?query=$name',
      fromJson: fromJson,
    );
  }
}
