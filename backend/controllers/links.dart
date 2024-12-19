import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus linksRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final links = await _supabase
      .from('link')
      .select();
    return sendOk(links);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final href = queryParams["query"] ?? "";
    final link = await _supabase
      .from('link')
      .select()
      .ilike('href', href)
      .single();
    return sendOk(link);
  });

  router.get('/<id>', (Request req, String id) async {
    final link = await _supabase
      .from('link')
      .select()
      .eq('id', id)
      .single();
    return sendOk(link);
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
        "href",
      ]
    );

    final link = await _supabase
      .from('link')
      .insert(body)
      .select()
      .single();
    return sendCreated(link);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
      ]
    );

    final link = await _supabase
      .from('link')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(link);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('medialink')
      .delete()
      .eq('linkid', id);

    await _supabase
      .from('link')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
