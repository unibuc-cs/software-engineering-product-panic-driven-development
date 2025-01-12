import '../Models/link.dart';
import 'general/service.dart';

class LinkService extends Service<Link> {
  LinkService._() : super(Link.endpoint, Link.from);
  
  static final LinkService _instance = LinkService._();

  static LinkService get instance => _instance;
}
