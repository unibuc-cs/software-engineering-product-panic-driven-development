import 'dart:core';
import 'config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<T> request<T>({
  required String method,
  required String endpoint,
  dynamic body,
  required T Function(dynamic) fromJson,
}) async {
  http.Response response;
  String errMsg, methodUpper = method.toUpperCase();
  Map<String, String> headers = {'Content-Type': 'application/json'};

  if (methodUpper == 'POST') {
    response = await axios.post(endpoint, body, headers: headers);
    errMsg = 'Failed to create data at $endpoint: ${response.statusCode}';
  }
  else if (methodUpper == 'PUT') {
    response = await axios.put(endpoint, body, headers: headers);
    errMsg = 'Failed to update data at $endpoint: ${response.statusCode}';
  }
  else if (methodUpper == 'GET') {
    response = await axios.get(endpoint);
    errMsg = 'Failed to load data from $endpoint: ${response.statusCode}';
  }
  else if (methodUpper == 'DELETE') {
    response = await axios.delete(endpoint);
    errMsg = 'Failed to delete data at $endpoint: ${response.statusCode}';
  }
  else {
    throw UnsupportedError('HTTP method $method is not supported');
  }

  if (response.statusCode < 200 || response.statusCode > 299) {
    throw Exception(errMsg);
  }
  if (methodUpper == 'DELETE') {
    return fromJson(null);
  }
  return fromJson(jsonDecode(response.body));
}
