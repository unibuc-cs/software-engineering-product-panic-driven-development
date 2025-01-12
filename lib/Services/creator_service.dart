import 'general/service.dart';
import '../Models/creator.dart';

class CreatorService extends Service<Creator> {
  CreatorService._() : super(Creator.endpoint, Creator.from);
  
  static final CreatorService _instance = CreatorService._();

  static CreatorService get instance => _instance;
}
