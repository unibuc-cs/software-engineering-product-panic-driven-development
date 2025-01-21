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

String capitalize(String str) => str.replaceFirst(str[0], str[0].toUpperCase());

String extractFileName(String path) => path.substring(path.lastIndexOf('\\') + 1, path.length - 11);

String padEnd(String input, int length, [String pad = ' ']) =>
  input.length >= length
    ? input
    : input + pad * (length - input.length);
