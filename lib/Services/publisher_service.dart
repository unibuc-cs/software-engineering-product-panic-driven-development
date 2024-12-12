import 'general/service.dart';
import '../Models/publisher.dart';

class PublisherService extends Service<Publisher> {
  PublisherService()
      : super(
          resource: 'publishers',
          fromJson: (json) => Publisher.from(json),
          toJson  : (publisher) => publisher.toSupa(),
        );
}

