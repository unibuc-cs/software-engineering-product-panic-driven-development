import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus publishersRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final publishers = await _supabase
      .from('publisher')
      .select();
    return sendOk(publishers);
  });

  router.get('/<id>', (Request req, String id) async {
    final publisher = await _supabase
      .from('publisher')
      .select()
      .eq('id', id)
      .single();
    return sendOk(publisher);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        "name"
      ]
    );

    final publisher = await _supabase
      .from('publisher')
      .insert(body)
      .select()
      .single();
    return sendCreated(publisher);
  });

  router.put('/<id>', (Request req, String id) async {
    final body = await req.body.asJson;
    validateBody(body);

    final publisher = await _supabase
      .from('publisher')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(publisher);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('publisher')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
