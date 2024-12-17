import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus appAchievementsRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final appAchievements = await _supabase
      .from('appachievement')
      .select();
    return sendOk(appAchievements);
  });

  router.get('/<id>', (Request req, String id) async {
    final appAchievement = await _supabase
      .from('appachievement')
      .select()
      .eq('id',id)
      .single();
    return sendOk(appAchievement);
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
        "description",
      ]
    );
    populateBody(body, defaultFields:
      {
        "xp": 100,
      }
    );

    final appAchievement = await _supabase
      .from('appachievement')
      .insert(body)
      .select()
      .single();
    return sendCreated(appAchievement);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
      ]
    );

    final appAchievement = await _supabase
      .from('appachievement')
      .update(body)
      .eq('id',id)
      .select()
      .single();
    return sendOk(appAchievement);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('appachievement')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}