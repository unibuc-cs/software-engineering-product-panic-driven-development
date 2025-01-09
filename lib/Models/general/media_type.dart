import '../media.dart';

abstract class MediaType {
  Future<Media> get media async {
    throw UnimplementedError('Getter media was not defined for this type');
  }

  int getMediaId() {
    throw UnimplementedError('Getter getMediaId was not defined for this type');
  }
}