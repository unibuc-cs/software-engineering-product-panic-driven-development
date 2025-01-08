import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaUserGenresRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final userId = SupabaseClientSingleton.userId;
    final mediaUserGenres = await supabase
      .from('mediausergenre')
      .select()
      .eq('userid', userId!);
    return sendOk(mediaUserGenres);
  });

  router.get('/<mediaId>/<genreId>', (Request req, String mediaId, String genreId) async {
    final userId = SupabaseClientSingleton.userId;
    final mediaUserGenre = await supabase
      .from('mediausergenre')
      .select()
      .eq('mediaid', mediaId)
      .eq('userid', userId!)
      .eq('genreid', genreId)
      .single();
    return sendOk(mediaUserGenre);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'mediaid',
        'genreid',
      ]
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    await validateExistence(body['genreid'], 'genre', supabase);
    body['userid'] = SupabaseClientSingleton.userId;
    
    final mediaUserGenre = await supabase
      .from('mediausergenre')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaUserGenre);
  });

  router.delete('/<mediaId>/<genreId>', (Request req, String mediaId, String genreId) async {
    final userId = SupabaseClientSingleton.userId;
    
    await supabase
      .from('mediausergenre')
      .delete()
      .eq('mediaid', mediaId)
      .eq('userid', userId!)
      .eq('genreid', genreId);
    return sendNoContent();
  });

  return router;
}
