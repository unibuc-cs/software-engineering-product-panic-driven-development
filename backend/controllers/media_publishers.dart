import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaPublishersRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaPublishers = await supabase
      .from('mediapublisher')
      .select();
    return sendOk(mediaPublishers);
  });

  router.get('/<mediaId>/<publisherId>', (Request req, String mediaId, String publisherId) async {
    final mediaPublisher = await supabase
      .from('mediapublisher')
      .select()
      .eq('mediaid', mediaId)
      .eq('publisherid', publisherId)
      .single();
    return sendOk(mediaPublisher);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'mediaid',
        'publisherid',
      ]
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['publisherid'], 'publisher', supabase);

    final mediaPublisher = await supabase
      .from('mediapublisher')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaPublisher);
  });

  router.put('/<mediaId>/<publisherId>', (Request req, String mediaId, String publisherId) async {
    final body = await req.body.asJson;
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['publisherid'], 'publisher', supabase);

    final mediaPublisher = await supabase
      .from('mediapublisher')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('publisherid', publisherId)
      .select()
      .single();
    return sendOk(mediaPublisher);
  });

  router.delete('/<mediaId>/<publisherId>', (Request req, String mediaId, String publisherId) async {
    await supabase
      .from('mediapublisher')
      .delete()
      .eq('mediaid', mediaId)
      .eq('publisherid', publisherId);
    return sendNoContent();
  });

  return router;
}
