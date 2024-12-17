import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus tagsRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final tags = await _supabase
      .from('tag')
      .select();
    return sendOk(tags);
  });

  router.get('/<id>', (Request req, String id) async {
    final tag = await _supabase
      .from('tag')
      .select()
      .eq('id',id)
      .single();
    return sendOk(tag);
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

    final tag = await _supabase
      .from('tag')
      .insert(body)
      .select()
      .single();
    return sendCreated(tag);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
      ]
    );

    final tag = await _supabase
      .from('tag')
      .update(body)
      .eq('id',id)
      .select()
      .single();
    return sendOk(tag);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('tag')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}