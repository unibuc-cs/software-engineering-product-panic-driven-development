import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';

Response jsonResponse(Map<String, dynamic> data) {
  final jsonData = jsonEncode(data);
  return Response.ok(jsonData, headers: {'Content-Type': 'application/json'});
}

Map<String, dynamic> serialize(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is DateTime) {
      return MapEntry(key, value.toIso8601String());
    } else if (value is Map) {
      return MapEntry(key, serialize(Map<String, dynamic>.from(value)));
    } else if (value is List) {
      return MapEntry(key, value.map((e) => e is Map ? serialize(Map<String, dynamic>.from(e)) : e).toList());
    }
    return MapEntry(key, value);
  });
}
