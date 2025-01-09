import 'request.dart';
import '../../Models/model.dart';

class Service<T extends Model> {
  final String resource;
  late final T Function(dynamic) fromJson;

  Service(this.resource, fromJson) {
    this.fromJson = (json) => fromJson(json);
  }

  Future<T> create(dynamic model) async {
    Map<String, dynamic> body;

    if (model is T) {
      body = model.toJson();
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
      body    : model.toJson(),
      fromJson: fromJson,
    );
  }

  Future<void> delete(List<int> ids) async {
    await deleteRequest(
      endpoint: '/$resource/${ids.join('/')}',
    );
  }
}
