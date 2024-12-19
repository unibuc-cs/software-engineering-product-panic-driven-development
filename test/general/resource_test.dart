import 'dart:core';
import '../../lib/Models/model.dart';
import '../../lib/Services/general/service.dart';

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
  required T dummyItem,
  T? updatedItem,
  String? itemName,
  List<String>? tables
}) async {
  List<int> ids = [];
  try {
    final data = await service.create(dummyItem);
    Map<String, dynamic> dataMap = data.toJson();
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
      print('  ${item.toJson()}');
    });
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
      print('Got ${data.toJson()} by name ${itemName}');
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