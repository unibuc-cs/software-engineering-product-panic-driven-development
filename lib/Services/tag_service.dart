import '../Models/tag.dart';
import 'general/service.dart';

class TagService extends Service<Tag> {
  TagService() : super(
    resource: 'tags',
    fromJson: (json) => Tag.from(json),
    toJson: (tag) => tag.toJson(),
  );
}
