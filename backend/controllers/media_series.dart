import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaSeriesRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final mediaSeries = await _supabase
      .from('mediaseries')
      .select();
    return sendOk(mediaSeries);
  });

  router.get('/<mediaId>/<seriesId>', (Request req, String mediaId, String seriesId) async {
    final mediaSeries = await _supabase
      .from('mediaseries')
      .select()
      .eq('mediaid', mediaId)
      .eq('seriesid', seriesId)
      .single();
    return sendOk(mediaSeries);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        "mediaid",
        "seriesid",
        "index",
      ]
    );
    await validateExistence(body["mediaid"], 'media', _supabase);
    await validateExistence(body["seriesid"], 'series', _supabase);

    final mediaSeries = await _supabase
      .from('mediaseries')
      .insert(body)
      .select()
      .single();
    return sendCreated(mediaSeries);
  });

  router.put('/<mediaId>/<seriesId>', (Request req, String mediaId, String seriesId) async {
    final body = await req.body.asJson;
    await validateExistence(body["mediaid"], 'media', _supabase);
    await validateExistence(body["seriesid"], 'series', _supabase);

    final mediaSeries = await _supabase
      .from('mediaseries')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('seriesid', seriesId)
      .select()
      .single();
    return sendOk(mediaSeries);
  });

  router.delete('/<mediaId>/<seriesId>', (Request req, String mediaId, String seriesId) async {
    await _supabase
      .from('mediaseries')
      .delete()
      .eq('mediaid', mediaId)
      .eq('seriesid', seriesId);
    return sendNoContent();
  });

  return router;
}
