import 'general/service.dart';
import '../Models/publisher.dart';

class PublisherService extends Service<Publisher> {
  PublisherService._() : super(Publisher.endpoint, Publisher.from);
  
  static final PublisherService _instance = PublisherService._();

  static PublisherService get instance => _instance;
}

