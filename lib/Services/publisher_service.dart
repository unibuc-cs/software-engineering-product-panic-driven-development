import 'general/request.dart';
import 'general/service.dart';
import '../Models/publisher.dart';

class PublisherService extends Service<Publisher> {
  PublisherService()
      : super(
          resource: 'publishers',
          fromJson: (json) => Publisher.from(json),
          toJson  : (publisher) => publisher.toSupa(),
        );
  
  Future<Publisher> readByName(String name) async {
    return await request<Publisher>(
      method: 'GET',
      endpoint: '/publishers/name?query=$name',
      fromJson: fromJson,
    );
  }
}

