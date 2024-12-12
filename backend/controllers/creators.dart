import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus creatorsRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final creators = await _supabase
      .from('creator')
      .select();
    return sendOk(creators);
  });

  router.get('/<id>', (Request req, String id) async {
    final creator = await _supabase
      .from('creator')
      .select()
      .eq('id', id)
      .single();
    return sendOk(creator);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        "name"
      ]
    );

    final creator = await _supabase
      .from('creator')
      .insert(body)
      .select()
      .single();
    return sendCreated(creator);
  });

  router.put('/<id>', (Request req, String id) async {
    final body = await req.body.asJson;
    validateBody(body);

    final creator = await _supabase
      .from('creator')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(creator);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('creator')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
