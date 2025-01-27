import '../helpers/config.dart';

abstract class Provider {
  final config = Config.instance;

  Future<List<Map<String, dynamic>>> getOptions(String query) async {
    throw UnimplementedError('getOptions method is not implemented');
  }

  Future<Map<String, dynamic>> getInfo(String item) async {
    throw UnimplementedError('getInfo method is not implemented');
  }

  Future<List<Map<String, dynamic>>> getRecommendations(String item) async {
    throw UnimplementedError('getRecommendations method is not implemented');
  }

  String getKey() => 'id';
}
