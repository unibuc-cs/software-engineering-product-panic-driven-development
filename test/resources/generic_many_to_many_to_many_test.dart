import 'dart:core';
import '../../lib/Services/general/service_many_to_many_to_many.dart';

Future<void> runService<T>(
  ServiceManyToManyToMany<T> service,
  T dummy,
  T updatedDummy,
  String table1,
  String table2,
  String table3,
  Map<String, dynamic> Function(T) toJson,
) async {
  int id1 = 0, id2 = 0, id3 = 0;
  
  try {
    final data = await service.create(dummy);
    print('Created ${toJson(data)}');
    Map<String, dynamic> dataMap = toJson(data);
    id1 = dataMap["${table1}id"];
    id2 = dataMap["${table2}id"];
    id3 = dataMap["${table3}id"];
  }
  catch (e) {
    print('Create error: $e');
  }

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
    final data = await service.readById(id1, id2, id3);
    print('Got ${toJson(data)} by id');
  }
  catch (e) {
    print('GetById error: $e');
  }

  try {
    final data = await service.update(id1, id2, id3, updatedDummy);
    print('Updated ${toJson(data)}');
    Map<String, dynamic> dataMap = toJson(data);
    id1 = dataMap["${table1}id"];
    id2 = dataMap["${table2}id"];
    id3 = dataMap["${table3}id"];
  }
  catch (e) {
    print('Update error: $e');
  }

  try {
    await service.delete(id1, id2, id3);
    print('Deleted at ids $id1 and $id2 and $id3');
  }
  catch (e) {
    print('Delete error: $e');
  }
}