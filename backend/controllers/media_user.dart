import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaUsersRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaUsers = await supabase
      .from('mediauser')
      .select()
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendOk(mediaUsers);
  });

  router.get('/<mediaId>', (Request req, String mediaId) async {
    final mediaUser = await supabase
      .from('mediauser')
      .select()
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!)
      .single();
    return sendOk(mediaUser);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'mediaid',
        'name',
        'addeddate',
        'lastinteracted'
      ]
    );
    populateBody(body, defaultFields:
      {
        'status': 'Plan to Consume',
        'gametime': 0,
        'bookreadpages': 0,
        'nrepisodesseen': 0,
      }
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    body['userid'] = SupabaseClientSingleton.userId;

    final mediaUser = await supabase
      .from('mediauser')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaUser);
  });

  router.put('/<mediaId>', (Request req, String mediaId) async {
    final body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'mediaid',
        'userid',
      ]
    );

    final mediaUser = await supabase
      .from('mediauser')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!)
      .select()
      .single();
    return sendOk(mediaUser);
  });

  router.delete('/<mediaId>', (Request req, String mediaId) async {
    await supabase
      .from('mediauser')
      .delete()
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendNoContent();
  });

  return router;
}
