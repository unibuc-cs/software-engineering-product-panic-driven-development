import 'utils.dart';
import 'responses.dart';
import 'package:shelf/shelf.dart';

Handler logger(innerHandler) {
  return (Request request) async {
    final stopwatch = Stopwatch()..start();
    final response = await innerHandler(request);
    stopwatch.stop();
    final responseTime = stopwatch.elapsedMilliseconds;
    final method = request.method;
    final url = request.requestedUri.path;
    final status = response.statusCode;
    print('${greenColored(method)} $url ${greenColored(status)} - ${responseTime} ms');
    return response.change(headers: {'X-Response-Time': '$responseTime ms'});
  };
}

Handler errorHandling(innerHandler) {
  return (Request request) async {
    try {
      return await innerHandler(request);
    }
    catch (error) {
      print(redColored(error));

      String errMsg = error.toString().toLowerCase();
      if (errMsg.contains('multiple (or no) rows')) {
        return sendNotFound('Resource not found');
      }
      if (errMsg.contains('could not find the')) {
        return sendBadRequest('Invalid body');
      }
      if (
        errMsg.contains('is required') ||
        errMsg.contains('cannot be empty') ||
        errMsg.contains('contain an id field') ||
        errMsg.contains('not found')
      ) {
        return sendBadRequest(capitalize(errMsg.replaceAll('exception: ', '')));
      }

      return sendInternalError(errMsg);
    }
  };
}
