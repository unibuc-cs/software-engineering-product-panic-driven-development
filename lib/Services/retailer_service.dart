import 'general/service.dart';
import '../Models/retailer.dart';

class RetailerService extends Service<Retailer> {
  RetailerService._() : super(Retailer.endpoint, Retailer.from);
  
  static final RetailerService _instance = RetailerService._();

  static RetailerService get instance => _instance;
}

