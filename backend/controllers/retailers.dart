import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus retailersRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final retailers = await supabase
      .from('retailer')
      .select();
    return sendOk(retailers);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final name = queryParams['query'] ?? '';
    final retailer = await supabase
      .from('retailer')
      .select()
      .ilike('name', name)
      .single();
    return sendOk(retailer);
  });

  router.get('/<id>', (Request req, String id) async {
    final retailer = await supabase
      .from('retailer')
      .select()
      .eq('id', id)
      .single();
    return sendOk(retailer);
  });

  router.post('/', (Request req) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
      ]
    );
    validateBody(body, fields:
      [
        'name',
      ]
    );

    final retailer = await supabase
      .from('retailer')
      .insert(body)
      .select()
      .single();
    return sendCreated(retailer);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
      ]
    );

    final retailer = await supabase
      .from('retailer')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(retailer);
  });

  router.delete('/<id>', (Request req, String id) async {
    await supabase
      .from('mediaretailer')
      .delete()
      .eq('retailerid', id);

    await supabase
      .from('retailer')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
