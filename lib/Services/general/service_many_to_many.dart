import 'request.dart';

class ServiceManyToMany<T> {
  final String resource;
  final T Function(dynamic) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  ServiceManyToMany({
    required this.resource,
    required this.fromJson,
    required this.toJson,
  });

  Future<T> create(T model) async {
    return await request<T>(
      method: 'POST',
      endpoint: '/$resource',
      body: toJson(model),
      fromJson: fromJson,
    );
  }

  Future<List<T>> readAll() async {
    return await request<List<T>>(
      method: 'GET',
      endpoint: '/$resource',
      fromJson: (json) => (json as List).map((data) => fromJson(data)).toList(),
    );
  }

  Future<T> readById(int id1, int id2) async {
    return await request<T>(
      method: 'GET',
      endpoint: '/$resource/$id1/$id2',
      fromJson: fromJson,
    );
  }

  Future<T> update(int id1, int id2, T model) async {
    return await request<T>(
      method: 'PUT',
      endpoint: '/$resource/$id1/$id2',
      body: toJson(model),
      fromJson: fromJson,
    );
  }

  Future<void> delete(int id1, int id2) async {
    return await request<void>(
      method: 'DELETE',
      endpoint: '/$resource/$id1/$id2',
      fromJson: (_) {},
    );
  }
}