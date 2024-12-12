import 'dart:convert';
import 'request.dart';

class Service<T> {
  final String resource;
  final T Function(dynamic) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  Service({
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

  Future<List<T>> getAll() async {
    return await request<List<T>>(
      method: 'GET',
      endpoint: '/$resource',
      fromJson: (json) => (json as List).map((data) => fromJson(data)).toList(),
    );
  }

  Future<T> getById(int id) async {
    return await request<T>(
      method: 'GET',
      endpoint: '/$resource/$id',
      fromJson: fromJson,
    );
  }

  Future<T> update(int id, T model) async {
    return await request<T>(
      method: 'PUT',
      endpoint: '/$resource/$id',
      body: toJson(model),
      fromJson: fromJson,
    );
  }

  Future<void> delete(int id) async {
    return await request<void>(
      method: 'DELETE',
      endpoint: '/$resource/$id',
      fromJson: (_) => null,
    );
  }
}
