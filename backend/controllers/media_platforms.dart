import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaPlatformsRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaPlatforms = await supabase
      .from('mediaplatform')
      .select();
    return sendOk(mediaPlatforms);
  });

  router.get('/<mediaId>/<platformId>', (Request req, String mediaId, String platformId) async {
    final mediaPlatform = await supabase
      .from('mediaplatform')
      .select()
      .eq('mediaid', mediaId)
      .eq('platformid', platformId)
      .single();
    return sendOk(mediaPlatform);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'mediaid',
        'platformid',
      ]
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['platformid'], 'platform', supabase);

    final mediaPlatform = await supabase
      .from('mediaplatform')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaPlatform);
  });

  router.put('/<mediaId>/<platformId>', (Request req, String mediaId, String platformId) async {
    final body = await req.body.asJson;
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['platformid'], 'platform', supabase);

    final mediaPlatform = await supabase
      .from('mediaplatform')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('platformid', platformId)
      .select()
      .single();
    return sendOk(mediaPlatform);
  });

  router.delete('/<mediaId>/<platformId>', (Request req, String mediaId, String platformId) async {
    await supabase
      .from('mediaplatform')
      .delete()
      .eq('mediaid', mediaId)
      .eq('platformid', platformId);
    return sendNoContent();
  });

  return router;
}
