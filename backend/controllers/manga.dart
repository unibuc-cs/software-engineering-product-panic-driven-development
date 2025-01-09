import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mangaRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final manga = await supabase
      .from('manga')
      .select();
    return sendOk(manga);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final mediaId = int.parse(queryParams['query'] ?? '');
    final manga = await supabase
      .from('manga')
      .select()
      .eq('mediaid', mediaId)
      .single();
    return sendOk(manga);
  });

  router.get('/<id>', (Request req, String id) async {
    final manga = await supabase
      .from('manga')
      .select()
      .eq('id', id)
      .single();
    return sendOk(manga);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;

    discardFromBody(body, fields:
      [
        'id',
        'status',
        'nrvolumes',
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

    body['mediatype'] = 'manga';
    final specificBodies = splitBody(body, mediaType: 'manga');
    final result = await createFromBody(specificBodies, supabase, mediaType: 'manga', mediaTypePlural: 'manga');
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

    final manga = await supabase
      .from('manga')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(manga);
  });

  // This is intended, because we don't want to delete any manga for caching
  router.delete('/<id>', (Request req, String id) async {
    return sendNoContent();
  });

  return router;
}
