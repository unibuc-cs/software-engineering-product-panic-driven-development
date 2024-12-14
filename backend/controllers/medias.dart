import '../helpers/utils.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediasRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final media = await _supabase
      .from('media')
      .select();
    return sendOk(serialize(media));
  });

  router.get('/<id>', (Request req, String id) async {
    final media = await _supabase
      .from('media')
      .select()
      .eq('id', id)
      .single();
    return sendOk(serialize(media));
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        "originalname",
        "description",
        "releasedate",
        "criticscore",
        "communityscore",
        "mediatype"
      ]
    );

    final media = await _supabase
      .from('media')
      .insert(body)
      .select()
      .single();
    return sendCreated(serialize(media));
  });

  router.put('/<id>', (Request req, String id) async {
    final body = await req.body.asJson;
    validateBody(body);

    final media = await _supabase
      .from('media')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(serialize(media));
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('mediacreator')
      .delete()
      .eq('mediaid', id);
    
    await _supabase
      .from('medialink')
      .delete()
      .eq('mediaid', id);

    await _supabase
      .from('mediaplatform')
      .delete()
      .eq('mediaid', id);
    
    await _supabase
      .from('mediapublisher')
      .delete()
      .eq('mediaid', id);

    await _supabase
      .from('mediaretailer')
      .delete()
      .eq('mediaid', id);

    await _supabase
      .from('media')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}