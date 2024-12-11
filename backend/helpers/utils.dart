import 'package:ansicolor/ansicolor.dart';

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

String capitalize(String str) {
    return str.replaceFirst(str[0], str[0].toUpperCase());
}

String colored(dynamic message, String color) {
  var pen = AnsiPen();
  if (color == "red") {
    pen = pen..red();
  }
  else if (color == "green") {
    pen = pen..xterm(10);
  }
  else if (color == "blue") {
    pen = pen..xterm(45);
  }
  else {
    pen..reset();
  }
  return pen(message.toString());
}

String redColored(message) => colored(message, "red");
String greenColored(message) => colored(message, "green");
String blueColored(message) => colored(message, "blue");

void startupLog(address, port) {
  print('${blueColored('[STARTED]')} Listening at http://$address:$port');
}
