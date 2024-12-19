import 'general/service.dart';
import '../Models/retailer.dart';

class RetailerService extends Service<Retailer> {
  RetailerService() : super(
    resource: 'retailers',
    fromJson: (json) => Retailer.from(json),
    toJson  : (retailer) => retailer.toJson(),
  );
}

