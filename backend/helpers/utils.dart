import 'dart:io';
import 'package:ansicolor/ansicolor.dart';

String capitalize(String str) {
    return str.replaceFirst(str[0], str[0].toUpperCase());
}

void coloredPrint(String message, String color) {
  var pen = AnsiPen();
  if (color == "red") {
    pen = pen..red();
  }
  else if (color == "green") {
    pen = pen..green();
  }
  else {
    pen..reset();
  }
  print(pen(message));
}

void redPrint(message) => coloredPrint(message, "red");
void greenPrint(message) => coloredPrint(message, "green");

void validate(Map<String, dynamic> body, {List<String> fields = const []}) {
  if (body["id"] != null) {
    throw Exception('The body shouldn\'t contain an id field');
  }
  for (var field in fields) {
    if (body[field] == null) {
      throw Exception('${capitalize(field)} is required');
    }
    else if (body[field].runtimeType == String && body[field] == "") {
      throw Exception('${capitalize(field)} cannot be empty');
    }
  }
}

dynamic serialize(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      else if (value is Map) {
        return MapEntry(key, serialize(Map<String, dynamic>.from(value)));
      }
      else if (value is List) {
        return MapEntry(key, value.map((e) => serialize(e)).toList());
      }
      return MapEntry(key, value);
    });
  }
  else if (data is List) {
    return data.map((e) => serialize(e)).toList();
  }
  return data;
}
