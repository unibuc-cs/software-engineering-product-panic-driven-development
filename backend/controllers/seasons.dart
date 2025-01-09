import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus seasonsRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final seasons = await supabase
      .from('season')
      .select();
    return sendOk(seasons);
  });

  router.get('/<id>', (Request req, String id) async {
    final season = await supabase
      .from('season')
      .select()
      .eq('id', id)
      .single();
    return sendOk(season);
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

    final season = await supabase
      .from('season')
      .insert(body)
      .select()
      .single();
    return sendCreated(season);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
      ]
    );

    final season = await supabase
      .from('season')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(season);
  });

  router.delete('/<id>', (Request req, String id) async {
    await supabase
      .from('season')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}