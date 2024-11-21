import 'Service.dart';

class ServiceHandler {
  static Future<List<Map<String, dynamic>>> getOptions(Service service, String query) {
    return service.getOptions(query) ?? Future.value([]);
  }

  static Future<Map<String, dynamic>> getInfo(Service service, String item) {
    return service.getInfo(item) ?? Future.value({});
  }

  static Future<List<Map<String, dynamic>>> getRecommendations(Service service, int id) async {
    return service.getRecommendations(id) ?? Future.value([]);
  }
}
