import 'package:dotenv/dotenv.dart';

abstract class Service {
  final env = DotEnv()..load();

  Future<List<Map<String, dynamic>>> getOptions(String query) async {
    throw UnimplementedError("getOptions method is not implemented");
  }

  Future<Map<String, dynamic>> getInfo(String item) async {
    throw UnimplementedError("getInfo method is not implemented");
  }

  Future<List<Map<String, dynamic>>> getRecommendations(int id) async {
        throw UnimplementedError("getRecommendations method is not implemented");
  }
}
