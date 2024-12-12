import 'general/service.dart';
import '../Models/creator.dart';

class CreatorService extends Service<Creator> {
  CreatorService()
      : super(
          resource: 'creators',
          fromJson: (json) => Creator.from(json),
          toJson  : (creator) => creator.toSupa(),
        );
}
