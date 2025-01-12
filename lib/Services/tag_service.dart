import '../Models/tag.dart';
import 'general/service.dart';

class TagService extends Service<Tag> {
  TagService._() : super(Tag.endpoint, Tag.from);
  
  static final TagService _instance = TagService._();

  static TagService get instance => _instance;
}
