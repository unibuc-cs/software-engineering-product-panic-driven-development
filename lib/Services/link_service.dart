import '../Models/link.dart';
import 'general/service.dart';

class LinkService extends Service<Link> {
  LinkService() : super(Link.endpoint, Link.from);
}
