import '../helpers/utils.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediasRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final media = await _supabase
      .from('media')
      .select();
    return sendOk(serialize(media));
  });

  router.get('/<id>', (Request req, String id) async {
    final media = await _supabase
      .from('media')
      .select()
      .eq('id', id)
      .single();
    return sendOk(serialize(media));
  });

  router.post('/', (Request req) async {
    dynamic body = await req.body.asJson;
    body = discardFromBody(body, fields:
      [
        "id",
      ]
    );
    validateBody(body, fields:
      [
        "originalname",
        "description",
        "releasedate",
        "criticscore",
        "communityscore",
        "mediatype",
      ]
    );

    final media = await _supabase
      .from('media')
      .insert(body)
      .select()
      .single();
    return sendCreated(serialize(media));
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    body = discardFromBody(body, fields:
      [
        "id",
        "mediatype",
      ]
    );

    final media = await _supabase
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