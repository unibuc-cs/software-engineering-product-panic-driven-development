import 'request.dart';
import 'package:mediamaster/Models/general/model.dart';

bool findMatch(dynamic modelId, List<int> ids) {
  if (modelId is int) {
    return ids.length == 1 && modelId == ids[0];
  }
  if (modelId is List<int>) {
    if (modelId.length != ids.length) {
      return false;
    }
    for (int i = 0; i < modelId.length; i++) {
      if (modelId[i] != ids[i]) {
        return false;
      }
    }
    return true;
  }
  return false;
}


class Service<T extends Model> {
  final String resource;
  late final T Function(dynamic) fromJson;
  List<T> _items = [];

  Service(this.resource, fromJson) {
    this.fromJson = (json) => fromJson(json);
  }

  Future<void> hydrate() async {
    _items.clear();
    _items.addAll(await readAll());
  }

  void unhydrate() {
    _items.clear();
  }

  List<T> get items => List.unmodifiable(_items);

  Future<dynamic> makePostRequest(dynamic model) async {
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

  void addToItems(dynamic model) {
    if (model == null) {
      return;
    }
    if (!(model is List)) {
      model = [model];
    }
    
    _items.addAll(model.map((item) => fromJson(item)));
  }

  Future<T> create(dynamic model) async {
    final item = fromJson(await makePostRequest(model));
    _items.add(item);
    return item;
  }

  Future<List<T>> readAll() async {
    return await getRequest<List<T>>(
      endpoint: '/$resource',
      fromJson: (json) => (json as List).map((data) => fromJson(data)).toList(),
    );
  }

  Future<T> readById(dynamic ids) async {
    if (ids is int) {
      ids = [ids];
    }

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

  Future<T> update(dynamic ids, dynamic model) async {
    if (ids is int) {
      ids = [ids];
    }
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

    T updatedItem = await putRequest<T>(
      endpoint: '/$resource/${ids.join('/')}',
      body    : body,
      fromJson: fromJson,
    );
    _items = _items
      .map<T>((item) => findMatch(item.id, ids) ? updatedItem : item)
      .toList();
    return updatedItem;
  }

  Future<void> delete(dynamic ids) async {
    if (ids is int) {
      ids = [ids];
    }

    _items.removeWhere((item) => findMatch(item.id, ids));
    await deleteRequest(
      endpoint: '/$resource/${ids.join('/')}',
    );
  }
}
