import 'utils.dart';
import 'dart:convert';
import 'responses.dart';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

Middleware logger() {
  return (Handler innerHandler) {
    return (Request request) async {
      final stopwatch = Stopwatch()..start();
      final response = await innerHandler(request);
      stopwatch.stop();
      final responseTime = stopwatch.elapsedMilliseconds;
      final method = request.method;
      final url = request.requestedUri.path;
      final status = response.statusCode;
      print('$method $url $status - ${responseTime} ms');
      return response.change(headers: {'X-Response-Time': '$responseTime ms'});
    };
  };
}

Middleware unknownEndpoint() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);

      if (response.statusCode == 404) {
        return Response.notFound('Endpoint not found');
      }

      return response;
    };
  };
}

Middleware errorHandling() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      }
      catch (error) {
        print('Error {type: ${error.runtimeType} message: ${error.toString()}}');

        String errMsg = error.toString().toLowerCase();
        if (errMsg.contains('multiple (or no) rows')) {
          return sendBadRequest('Invalid id');
        }
        if (errMsg.contains('could not find the')) {
          return sendBadRequest('Invalid body');
        }
        if (
          errMsg.contains('is required') ||
          errMsg.contains('cannot be empty') ||
          errMsg.contains('contain an id field')
        ) {
          return sendBadRequest(capitalize(errMsg.replaceAll('exception: ', '')));
        }

        return sendInternalError(errMsg);
      }
    };
  };
}
