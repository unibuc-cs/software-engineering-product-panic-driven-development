import '../Models/link.dart';
import 'general/request.dart';
import 'general/service.dart';

class LinkService extends Service<Link> {
  LinkService()
      : super(
          resource: 'links',
          fromJson: (json) => Link.from(json),
          toJson  : (link) => link.toSupa(),
        );
  
  Future<Link> readByName(String name) async {
    return await request<Link>(
      method: 'GET',
      endpoint: '/links/name?query=$name',
      fromJson: fromJson,
    );
  }
}