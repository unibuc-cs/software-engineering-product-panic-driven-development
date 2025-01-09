import '../helpers/utils.dart';
import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediasRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final media = await supabase
      .from('media')
      .select();
    return sendOk(serialize(media));
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final originalname = queryParams['query'] ?? '';
    final media = await supabase
      .from('media')
      .select()
      .ilike('originalname', originalname)
      .single();
    return sendOk(media);
  });

  router.get('/<id>', (Request req, String id) async {
    final media = await supabase
      .from('media')
      .select()
      .eq('id', id)
      .single();
    return sendOk(serialize(media));
  });

  router.post('/', (Request req) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
      ]
    );

    final media = await supabase
      .from('media')
      .insert(body)
      .select()
      .single();
    return sendCreated(serialize(media));
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
        'mediatype',
      ]
    );

    final media = await supabase
      .from('media')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(serialize(media));
  });

  // This is intended, because we don't want to delete any form of media for caching
  router.delete('/<id>', (Request req, String id) async {
    return sendNoContent();
  });

  return router;
}