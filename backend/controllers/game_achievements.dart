import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus gameAchievementsRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final gameAchievements = await supabase
      .from('gameachievement')
      .select();
    return sendOk(gameAchievements);
  });

  router.get('/<id>', (Request req, String id) async {
    final gameAchievement = await supabase
      .from('gameachievement')
      .select()
      .eq('id', id)
      .single();
    return sendOk(gameAchievement);
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
        'gameid',
        'name',
        'description',
      ]
    );

    final gameAchievement = await supabase
      .from('gameachievement')
      .insert(body)
      .select()
      .single();
    return sendCreated(gameAchievement);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
        'gameid',
      ]
    );

    final gameAchievement = await supabase
      .from('gameachievement')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(gameAchievement);
  });

  router.delete('/<id>', (Request req, String id) async {
    await supabase
      .from('gameachievement')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}