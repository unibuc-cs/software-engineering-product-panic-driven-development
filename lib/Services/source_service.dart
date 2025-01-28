import '../Models/source.dart';
import 'general/service.dart';

class SourceService extends Service<Source> {
  SourceService._() : super(Source.endpoint, Source.from);
  static final SourceService _instance = SourceService._();

  static SourceService get instance => _instance;
}
