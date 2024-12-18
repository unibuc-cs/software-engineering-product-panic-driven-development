import 'dart:core';
import '../../lib/Services/general/service.dart';

Future<int> getValidId<T>({
  required Service<T> service,
  required Map<String, dynamic> backup
}) async {
  List<dynamic> itemList = await service.readAll();
  return itemList.isEmpty
    ? ((await service.create(backup)) as dynamic).id
    : itemList[0].id;
}

Future<void> runService<T>({
  required Service<T> service,
  required T dummyItem,
  T? updatedItem,
  required Map<String, dynamic> Function(T) toJson,
  String? itemName,
  List<String>? tables
}) async {
  List<int> ids = [];
  try {
    final data = await service.create(dummyItem);
    Map<String, dynamic> dataMap = toJson(data);
    print('Created ${dataMap}');
    if (tables != null) {
      ids = tables
        .map((table) => dataMap["${table}id"] as int)
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
      : 'ids ${ids.join(", ")}';

  try {
    final data = await service.readAll();
    print('Got all\n[');
    data.forEach((item) {
      print('  ${toJson(item)}');
    });
    print(']');
  }
  catch (e) {
    print('GetAll error: $e');
  }

  try {
    final data = await service.readById(ids);
    print('Got ${toJson(data)} by $idDescription');
  }
  catch (e) {
    print('GetById error: $e');
  }

  if (itemName != null) {
    try {
      final data = await service.readByName(itemName);
      print('Got ${toJson(data)} by name ${itemName}');
    }
    catch (e) {
      print('GetByName error: $e');
    }
  }

  if (updatedItem != null) {
    try {
      final data = await service.update(ids, updatedItem);
      print('Updated ${toJson(data)} for $idDescription');
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