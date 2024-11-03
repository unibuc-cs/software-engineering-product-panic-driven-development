import 'Service.dart';

class ServiceHandler {
  static Service? _service;
  static String? _key;

  static void setService(Service service) {
    _service = service;
  }

  static void setKey(String key) {
    _key = key;
  }

  static String? getKey() {
    return _key;
  }

  static Future<List<Map<String, dynamic>>> getOptions(String query) {
    return _service?.getOptions(query) ?? Future.value([]);
  }

  static Future<Map<String, dynamic>> getInfo(String item) {
    return _service?.getInfo(item) ?? Future.value({});
  }

  static Future<List<Map<String, dynamic>>> getRecommendations(int id) async {
    return _service?.getRecommendations(id) ?? Future.value([]);
  }
}
