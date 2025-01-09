import 'general/service.dart';
import '../Models/publisher.dart';

class PublisherService extends Service<Publisher> {
  PublisherService() : super(Publisher.endpoint, Publisher.from);
}

