import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus creatorsRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final creators = await supabase
      .from('creator')
      .select();
    return sendOk(creators);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final name = queryParams['query'] ?? '';
    final creator = await supabase
      .from('creator')
      .select()
      .ilike('name', name)
      .single();
    return sendOk(creator);
  });

  router.get('/<id>', (Request req, String id) async {
    final creator = await supabase
      .from('creator')
      .select()
      .eq('id', id)
      .single();
    return sendOk(creator);
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

    final creator = await supabase
      .from('creator')
      .insert(body)
      .select()
      .single();
    return sendCreated(creator);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
      ]
    );

    final creator = await supabase
      .from('creator')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(creator);
  });

  router.delete('/<id>', (Request req, String id) async {
    await supabase
      .from('mediacreator')
      .delete()
      .eq('creatorid', id);

    await supabase
      .from('creator')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
