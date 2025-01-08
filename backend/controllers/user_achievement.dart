import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus userAchievementsRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final userId = SupabaseClientSingleton.userId;
    final userAchievements = await supabase
      .from('userachievement')
      .select()
      .eq('userid', userId!);
    return sendOk(userAchievements);
  });

  router.get('/<achievementId>', (Request req, String achievementId) async {
    final userId = SupabaseClientSingleton.userId;
    final userAchievement = await supabase
      .from('userachievement')
      .select()
      .eq('achievementid', achievementId)
      .eq('userid', userId!)
      .single();
    return sendOk(userAchievement);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'achievementid',
        'unlockdate',
      ]
    );
    await validateExistence(body['achievementid'], 'appachievement', supabase);
    body['userid'] = SupabaseClientSingleton.userId;

    final userAchievement = await supabase
      .from('userachievement')
      .insert(body)
      .select()
      .single();
    return sendCreated(userAchievement);
  });

  router.put('/<achievementId>', (Request req, String achievementId) async {
    final body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'achievementid',
        'userid',
      ]
    );
    final userId = SupabaseClientSingleton.userId;

    final userAchievement = await supabase
      .from('userachievement')
      .update(body)
      .eq('achievementid', achievementId)
      .eq('userid', userId!)
      .select()
      .single();
    return sendOk(userAchievement);
  });

  router.delete('/<achievementId>', (Request req, String achievementId) async {
    final userId = SupabaseClientSingleton.userId;
    
    await supabase
      .from('userachievement')
      .delete()
      .eq('achievementid', achievementId)
      .eq('userid', userId!);
    return sendNoContent();
  });

  return router;
}
