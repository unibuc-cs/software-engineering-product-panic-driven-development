import '../Models/tag.dart';
import 'general/service.dart';

class TagService extends Service<Tag> {
  TagService() : super(Tag.endpoint, Tag.from);
}
