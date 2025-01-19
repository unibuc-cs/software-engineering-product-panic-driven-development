import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaGenresRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaGenres = await supabase
      .from('mediagenre')
      .select();
    return sendOk(mediaGenres);
  });

  router.get('/<mediaId>/<genreId>', (Request req, String mediaId, String genreId) async {
    final mediaGenre = await supabase
      .from('mediagenre')
      .select()
      .eq('mediaid', mediaId)
      .eq('genreid', genreId)
      .single();
    return sendOk(mediaGenre);
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

    final mediaGenre = await supabase
      .from('mediagenre')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaGenre);
  });

  router.delete('/<mediaId>/<genreId>', (Request req, String mediaId, String genreId) async {
    await supabase
      .from('mediagenre')
      .delete()
      .eq('mediaid', mediaId)
      .eq('genreid', genreId);
    return sendNoContent();
  });

  return router;
}
