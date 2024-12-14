import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaCreatorsRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaCreators = await _supabase
      .from('mediacreator')
      .select();
    return sendOk(mediaCreators);
  });

  router.get('/<mediaId>/<creatorId>', (Request req, String mediaId, String creatorId) async {
    final mediaCreator = await _supabase
      .from('mediacreator')
      .select()
      .eq('mediaid', mediaId)
      .eq('creatorid', creatorId)
      .single();
    return sendOk(mediaCreator);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        "mediaid",
        "creatorid",
      ]
    );
    await validateExistence(body["mediaid"], 'media', _supabase);
    await validateExistence(body["creatorid"], 'creator', _supabase);

    final mediaCreator = await _supabase
      .from('mediacreator')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaCreator);
  });

  router.put('/<mediaId>/<creatorId>', (Request req, String mediaId, String creatorId) async {
    final body = await req.body.asJson;
    await validateExistence(body["mediaid"], 'media', _supabase);
    await validateExistence(body["creatorid"], 'creator', _supabase);

    final mediaCreator = await _supabase
      .from('mediacreator')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('creatorid', creatorId)
      .select()
      .single();
    return sendOk(mediaCreator);
  });

  router.delete('/<mediaId>/<creatorId>', (Request req, String mediaId, String creatorId) async {
    await _supabase
      .from('mediacreator')
      .delete()
      .eq('mediaid', mediaId)
      .eq('creatorid', creatorId);
    return sendNoContent();
  });

  return router;
}
