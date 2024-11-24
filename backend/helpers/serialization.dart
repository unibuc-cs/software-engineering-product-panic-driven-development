import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';

Response mapToJson(Map<String, dynamic> data) {
  final jsonData = jsonEncode(data);
  return Response.ok(jsonData, headers: {'Content-Type': 'application/json'});
}

Response listToJson(List<Map<String, dynamic>> dataList) {
  final jsonData = jsonEncode(dataList);
  return Response.ok(jsonData, headers: {'Content-Type': 'application/json'});
}

Map<String, dynamic> serializeMap(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is DateTime) {
      return MapEntry(key, value.toIso8601String());
    }
    else if (value is Map) {
      return MapEntry(key, serializeMap(Map<String, dynamic>.from(value)));
    }
    else if (value is List) {
      return MapEntry(key, value.map((e) => e is Map ? serializeMap(Map<String, dynamic>.from(e)) : e).toList());
    }
    return MapEntry(key, value);
  });
}

List<Map<String, dynamic>> serializeList(List<Map<String, dynamic>> dataList) {
  return dataList.map((data) => serializeMap(data)).toList();
}
