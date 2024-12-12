import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus retailersRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final retailers = await _supabase
      .from('retailer')
      .select();
    return sendOk(retailers);
  });

  router.get('/<id>', (Request req, String id) async {
    final retailer = await _supabase
      .from('retailer')
      .select()
      .eq('id', id)
      .single();
    return sendOk(retailer);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        "name"
      ]
    );

    final retailer = await _supabase
      .from('retailer')
      .insert(body)
      .select()
      .single();
    return sendCreated(retailer);
  });

  router.put('/<id>', (Request req, String id) async {
    final body = await req.body.asJson;
    validateBody(body);

    final retailer = await _supabase
      .from('retailer')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(retailer);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('retailer')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
