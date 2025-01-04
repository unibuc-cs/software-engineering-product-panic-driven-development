import 'dart:core';
import 'config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String getErrMsg(String? body, String fallbackMsg) {
  return (body != null && body!.isNotEmpty && body!.contains('error'))
    ? body.split('{"error":"')[1].split('"}')[0]
    : fallbackMsg;
}

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
    errMsg = getErrMsg(
      response?.body,
      'Failed to create data at $endpoint: ${response.statusCode}'
    );
  }
  else if (methodUpper == 'PUT') {
    response = await axios.put(endpoint, body, headers: headers);
    errMsg = getErrMsg(
      response?.body,
      'Failed to update data at $endpoint: ${response.statusCode}'
    );
  }
  else if (methodUpper == 'GET') {
    response = await axios.get(endpoint);
    errMsg = getErrMsg(
      response?.body,
      'Failed to read data at $endpoint: ${response.statusCode}'
    );
  }
  else if (methodUpper == 'DELETE') {
    response = await axios.delete(endpoint);
    return Future.value(null);
  }
  else {
    throw UnsupportedError('HTTP method $method is not supported');
  }

  if (response.statusCode < 200 || response.statusCode > 299) {
    throw Exception(errMsg);
  }
  if (response.body.isEmpty) {
    return fromJson({});
  }
  return fromJson(jsonDecode(response.body));
}

Future<T> postRequest<T>({
  required String endpoint,
  required dynamic body,
  required T Function(dynamic) fromJson,
}) async {
  return await request<T>(
    method: 'POST',
    endpoint: endpoint,
    body: body,
    fromJson: fromJson,
  );
}

Future<T> getRequest<T>({
  required String endpoint,
  required T Function(dynamic) fromJson,
}) async {
  return await request<T>(
    method: 'GET',
    endpoint: endpoint,
    fromJson: fromJson,
  );
}

Future<T> putRequest<T>({
  required String endpoint,
  required dynamic body,
  required T Function(dynamic) fromJson,
}) async {
  return await request<T>(
    method: 'PUT',
    endpoint: endpoint,
    body: body,
    fromJson: fromJson,
  );
}

Future<void> deleteRequest({
  required String endpoint,
}) async {
  await request<void>(
    method: 'DELETE',
    endpoint: endpoint,
    fromJson: (_) => null,
  );
}