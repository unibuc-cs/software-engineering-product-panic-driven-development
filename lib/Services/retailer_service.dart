import 'general/service.dart';
import '../Models/retailer.dart';

class RetailerService extends Service<Retailer> {
  RetailerService() : super(Retailer.endpoint, Retailer.from);
}

