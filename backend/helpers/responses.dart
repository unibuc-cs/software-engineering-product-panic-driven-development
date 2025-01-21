import 'dart:convert';
import 'package:shelf/shelf.dart';

Response sendResponse(dynamic data, String status) {
  final headersJson = { 'Content-Type': 'application/json' };
  final dataBody = jsonEncode(data);
  final errBody = jsonEncode({ 'error': data });

  switch (status) {
    case '200':
      return Response.ok(
        dataBody,
        headers: headersJson
      );
    case '201':
      return Response(
        201,
        body: dataBody,
        headers: headersJson
      );
    case '204':
      return Response(204);
    case '400':
      return Response.badRequest(
        body: errBody,
        headers: headersJson
      );
    case '401':
      return Response(
        401,
        body: errBody,
        headers: headersJson
      );
    case '404':
      return Response.notFound(
        errBody,
        headers: headersJson
      );
    case '409':
      return Response(
        409,
        body: errBody,
        headers: headersJson
      );
  }
  return Response.internalServerError(
    body: errBody,
    headers: headersJson
  );
}

Response sendOk(data) => sendResponse(data, '200');
Response sendCreated(data) => sendResponse(data, '201');
Response sendNoContent() => sendResponse('', '204');
Response sendBadRequest(data) => sendResponse(data, '400');
Response sendUnauthorized(data) => sendResponse(data, '401');
Response sendNotFound(data) => sendResponse(data, '404');
Response sendConflict(data) => sendResponse(data, '409');
Response sendInternalError(data) => sendResponse(data, '500');
Response unknownEndpoint(Request req) => sendNotFound('Endpoint not found');
Response faviconNotFound(Request req) => sendNotFound('No favicon');

Response handleServiceErrors(String error) {
  final errorLower = error.toLowerCase();
  if (errorLower.contains('something went wrong')) {
    return sendInternalError(error);
  }
  else if (
    errorLower.startsWith('no') ||
    errorLower.contains('found')
  ) {
    return sendNotFound(error);
  }
  return sendBadRequest(error);
}
