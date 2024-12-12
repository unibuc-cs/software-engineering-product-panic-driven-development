import 'dart:core';
import '../../lib/Services/general/service.dart';

Future<void> runService<T>(
  Service<T> service,
  T dummy,
  T updatedDummy,
  Map<String, dynamic> Function(T) toJson,
) async {
  int id = 0;

  try {
    final data = await service.create(dummy);
    print('Created ${toJson(data)}');
    id = (data as dynamic).id;
  }
  catch (e) {
    print('Create error: $e');
  }

  try {
    final data = await service.getAll();
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
    final data = await service.getById(id);
    print('Got ${toJson(data)} by id');
  }
  catch (e) {
    print('GetById error: $e');
  }

  try {
    final data = await service.update(id, updatedDummy);
    print('Updated ${toJson(data)}');
  }
  catch (e) {
    print('Update error: $e');
  }

  try {
    await service.delete(id);
    print('Deleted at id $id');
  }
  catch (e) {
    print('Delete error: $e');
  }
}