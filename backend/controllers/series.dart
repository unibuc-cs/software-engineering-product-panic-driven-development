import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus seriesRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final series = await _supabase
      .from('series')
      .select();
    return sendOk(series);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final name = queryParams["query"] ?? "";
    final series = await _supabase
      .from('series')
      .select()
      .ilike('name', name)
      .single();
    return sendOk(series);
  });

  router.get('/<id>', (Request req, String id) async {
    final series = await _supabase
      .from('series')
      .select()
      .eq('id', id)
      .single();
    return sendOk(series);
  });

  router.post('/', (Request req) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
      ]
    );
    validateBody(body, fields:
      [
        "name",
      ]
    );

    final series = await _supabase
      .from('series')
      .insert(body)
      .select()
      .single();
    return sendCreated(series);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
      ]
    );

    final series = await _supabase
      .from('series')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(series);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('mediaseries')
      .delete()
      .eq('seriesid', id);
    
    await _supabase
      .from('series')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
