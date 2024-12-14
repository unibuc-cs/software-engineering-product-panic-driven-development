import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaRetailersRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaRetailers = await _supabase
      .from('mediaretailer')
      .select();
    return sendOk(mediaRetailers);
  });

  router.get('/<mediaId>/<retailerId>', (Request req, String mediaId, String retailerId) async {
    final mediaRetailer = await _supabase
      .from('mediaretailer')
      .select()
      .eq('mediaid', mediaId)
      .eq('retailerid', retailerId)
      .single();
    return sendOk(mediaRetailer);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        "mediaid",
        "retailerid",
      ]
    );
    await validateExistence(body["mediaid"], 'media', _supabase);
    await validateExistence(body["retailerid"], 'retailer', _supabase);

    final mediaRetailer = await _supabase
      .from('mediaretailer')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaRetailer);
  });

  router.put('/<mediaId>/<retailerId>', (Request req, String mediaId, String retailerId) async {
    final body = await req.body.asJson;
    await validateExistence(body["mediaid"], 'media', _supabase);
    await validateExistence(body["retailerid"], 'retailer', _supabase);

    final mediaRetailer = await _supabase
      .from('mediaretailer')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('retailerid', retailerId)
      .select()
      .single();
    return sendOk(mediaRetailer);
  });

  router.delete('/<mediaId>/<retailerId>', (Request req, String mediaId, String retailerId) async {
    await _supabase
      .from('mediaretailer')
      .delete()
      .eq('mediaid', mediaId)
      .eq('retailerid', retailerId);
    return sendNoContent();
  });

  return router;
}
