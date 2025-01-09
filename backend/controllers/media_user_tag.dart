import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaUserTagsRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaUserTags = await supabase
      .from('mediausertag')
      .select()
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendOk(mediaUserTags);
  });

  router.get('/<mediaId>/<tagId>', (Request req, String mediaId, String tagId) async {
    final mediaUserTag = await supabase
      .from('mediausertag')
      .select()
      .eq('tagid', tagId)
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!)
      .single();
    return sendOk(mediaUserTag);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'mediaid',
        'tagid',
      ]
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['tagid'], 'tag', supabase);
    body['userid'] = SupabaseClientSingleton.userId;

    final mediaUserTag = await supabase
      .from('mediausertag')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaUserTag);
  });

  router.delete('/<mediaId>/<tagId>', (Request req, String mediaId, String tagId) async {
    await supabase
      .from('mediausertag')
      .delete()
      .eq('mediaid', mediaId)
      .eq('tagid', tagId)
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendNoContent();
  });

  return router;
}
