import 'general/service.dart';
import '../Models/creator.dart';

class CreatorService extends Service<Creator> {
  CreatorService() : super(Creator.endpoint, Creator.from);
}
