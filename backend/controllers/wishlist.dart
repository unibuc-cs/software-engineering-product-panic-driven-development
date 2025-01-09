import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus wishlistsRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final wishlists = await supabase
      .from('wishlist')
      .select()
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendOk(wishlists);
  });

  router.get('/<mediaId>', (Request req, String mediaId) async {
    final wishlist = await supabase
      .from('wishlist')
      .select()
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!)
      .single();
    return sendOk(wishlist);
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
      }
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    body['userid'] = SupabaseClientSingleton.userId;

    final wishlist = await supabase
      .from('wishlist')
      .insert(body)
      .select()
      .single();
    return sendCreated(wishlist);
  });

  router.put('/<mediaId>', (Request req, String mediaId) async {
    final body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'mediaid',
        'userid',
      ]
    );

    final wishlist = await supabase
      .from('wishlist')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!)
      .select()
      .single();
    return sendOk(wishlist);
  });

  router.delete('/<mediaId>', (Request req, String mediaId) async {
    await supabase
      .from('wishlist')
      .delete()
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendNoContent();
  });

  return router;
}
