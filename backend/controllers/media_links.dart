import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaLinksRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaLinks = await supabase
      .from('medialink')
      .select();
    return sendOk(mediaLinks);
  });

  router.get('/<mediaId>/<linkId>', (Request req, String mediaId, String linkId) async {
    final mediaLink = await supabase
      .from('medialink')
      .select()
      .eq('mediaid', mediaId)
      .eq('linkid', linkId)
      .single();
    return sendOk(mediaLink);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'mediaid',
        'linkid',
      ]
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['linkid'], 'link', supabase);

    final mediaLink = await supabase
      .from('medialink')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaLink);
  });

  router.put('/<mediaId>/<linkId>', (Request req, String mediaId, String linkId) async {
    final body = await req.body.asJson;
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['linkid'], 'link', supabase);

    final mediaLink = await supabase
      .from('medialink')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('linkid', linkId)
      .select()
      .single();
    return sendOk(mediaLink);
  });

  router.delete('/<mediaId>/<linkId>', (Request req, String mediaId, String linkId) async {
    await supabase
      .from('medialink')
      .delete()
      .eq('mediaid', mediaId)
      .eq('linkid', linkId);
    return sendNoContent();
  });

  return router;
}
