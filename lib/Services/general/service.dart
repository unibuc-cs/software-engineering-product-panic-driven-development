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

  Future<T> create(dynamic model) async {
    Map<String, dynamic> body;

    if (model is T) {
      body = toJson(model);
    }
    else if (model is Map<String, dynamic>) {
      body = model;
    }
    else {
      throw ArgumentError('The model must be either a Map or an instance of $T');
    }

    return await postRequest<T>(
      endpoint: '/$resource',
      body    : body,
      fromJson: fromJson,
    );
  }

  Future<List<T>> readAll() async {
    return await getRequest<List<T>>(
      endpoint: '/$resource',
      fromJson: (json) => (json as List).map((data) => fromJson(data)).toList(),
    );
  }

  Future<T> readById(List<int> ids) async {
    return await getRequest<T>(
      endpoint: '/$resource/${ids.join('/')}',
      fromJson: fromJson,
    );
  }

  Future<T> readByName(String name) async {
    return await getRequest<T>(
      endpoint: '/$resource/name?query=$name',
      fromJson: fromJson,
    );
  }

  Future<T> update(List<int> ids, T model) async {
    return await putRequest<T>(
      endpoint: '/$resource/${ids.join('/')}',
      body    : toJson(model),
      fromJson: fromJson,
    );
  }

  Future<void> delete(List<int> ids) async {
    await deleteRequest(
      endpoint: '/$resource/${ids.join('/')}',
    );
  }
}
