import 'dart:core';
import 'package:mediamaster/Models/model.dart';
import 'package:mediamaster/Services/general/service.dart';

Future<int> getValidId<T extends Model>({
  required Service<T> service,
  required Map<String, dynamic> backup
}) async {
  List<dynamic> itemList = await service.readAll();
  return itemList.isEmpty
    ? ((await service.create(backup)) as dynamic).id
    : itemList[0].id;
}

Future<void> runService<T extends Model>({
  required Service<T> service,
  required dynamic dummyItem,
  T? updatedItem,
  String? itemName,
  List<String>? tables
}) async {
  List<int> ids = [];

  try {
    Map<String, dynamic> body = <String, dynamic>{};
    if (dummyItem is T) {
      body = dummyItem.toJson();
    }
    else if (dummyItem is Map<String, dynamic>) {
      body = dummyItem;
    }
    else {
      throw ArgumentError('The model must be either a Map or an instance of $T');
    }

    final data = await service.create(body);
    Map<String, dynamic> dataMap = data.toJson();
    print('Created $dataMap');
    if (tables != null) {
      ids = tables
        .map((table) => dataMap['${table}id'] as int)
        .toList();
    }
    else {
      ids = [(data as dynamic).id];
    }
  }
  catch (e) {
    print('Create error: $e');
  }

  final idDescription = ids.length == 1
      ? 'id ${ids[0]}'
      : 'ids ${ids.join(', ')}';

  try {
    final data = await service.readAll();
    print('Got all\n[');
    for (var item in data) {
      print('  ${item.toJson()}');
    }
    print(']');
  }
  catch (e) {
    print('GetAll error: $e');
  }

  try {
    final data = await service.readById(ids);
    print('Got ${data.toJson()} by $idDescription');
  }
  catch (e) {
    print('GetById error: $e');
  }

  if (itemName != null) {
    try {
      final data = await service.readByName(itemName);
      print('Got ${data.toJson()} by name $itemName');
    }
    catch (e) {
      print('GetByName error: $e');
    }
  }

  if (updatedItem != null) {
    try {
      final data = await service.update(ids, updatedItem);
      print('Updated ${data.toJson()} for $idDescription');
    }
    catch (e) {
      print('Update error: $e');
    }
  }

  try {
    await service.delete(ids);
    print('Deleted at $idDescription');
  }
  catch (e) {
    print('Delete error: $e');
  }
}