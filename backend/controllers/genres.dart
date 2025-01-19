import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus genresRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final genres = await supabase
      .from('genre')
      .select();
    return sendOk(genres);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final name = queryParams['query'] ?? '';
    final genre = await supabase
      .from('genre')
      .select()
      .ilike('name', name)
      .single();
    return sendOk(genre);
  });

  router.get('/<id>', (Request req, String id) async {
    final genre = await supabase
      .from('genre')
      .select()
      .eq('id', id)
      .single();
    return sendOk(genre);
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

    final genre = await supabase
      .from('genre')
      .insert(body)
      .select()
      .single();
    return sendCreated(genre);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
      ]
    );

    final genre = await supabase
      .from('genre')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(genre);
  });

  router.delete('/<id>', (Request req, String id) async {
    await supabase
      .from('genre')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}