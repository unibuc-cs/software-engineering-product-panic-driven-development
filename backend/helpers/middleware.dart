import 'package:shelf/shelf.dart';

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
