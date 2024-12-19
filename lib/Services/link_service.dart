import '../Models/link.dart';
import 'general/service.dart';

class LinkService extends Service<Link> {
  LinkService() : super(
    resource: 'links',
    fromJson: (json) => Link.from(json),
    toJson  : (link) => link.toJson(),
  );
}
