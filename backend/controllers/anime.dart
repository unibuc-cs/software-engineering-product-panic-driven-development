import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus animeRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final anime = await supabase
      .from('anime')
      .select();
    return sendOk(anime);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final mediaId = int.parse(queryParams['query'] ?? '');
    final anime = await supabase
      .from('anime')
      .select()
      .eq('mediaid', mediaId)
      .single();
    return sendOk(anime);
  });

  router.get('/<id>', (Request req, String id) async {
    final anime = await supabase
      .from('anime')
      .select()
      .eq('id', id)
      .single();
    return sendOk(anime);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;

    discardFromBody(body, fields:
      [
        'id',
        'status',
        'episodes', // this is temporary, just for testing
        'duration',
      ]
    );
    populateBody(body, defaultFields:
      {
        'creators': [],
        'publishers': [],
        'platforms': [],
        'links': [],
        'seriesname': [],
        'series': [],
      },
    );

    body['mediatype'] = 'anime';
    final specificBodies = splitBody(body, mediaType: 'anime');
    final result = await createFromBody(specificBodies, supabase, mediaType: 'anime', mediaTypePlural: 'anime');
    return sendOk(result);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
        'mediaid',
      ]
    );

    final anime = await supabase
      .from('anime')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(anime);
  });

  // This is intended, because we don't want to delete any anime for caching
  router.delete('/<id>', (Request req, String id) async {
    return sendNoContent();
  });

  return router;
}
