import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus platformsRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final platforms = await _supabase
      .from('platform')
      .select();
    return sendOk(platforms);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final name = queryParams["query"] ?? "";
    final platform = await _supabase
      .from('platform')
      .select()
      .ilike('name', name)
      .single();
    return sendOk(platform);
  });

  router.get('/<id>', (Request req, String id) async {
    final platform = await _supabase
      .from('platform')
      .select()
      .eq('id', id)
      .single();
    return sendOk(platform);
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

    final plaform = await _supabase
      .from('platform')
      .insert(body)
      .select()
      .single();
    return sendCreated(plaform);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
      ]
    );

    final platform = await _supabase
      .from('platform')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(platform);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('mediaplatform')
      .delete()
      .eq('platformid', id);

    await _supabase
      .from('platform')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
