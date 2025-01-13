import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus TVSeriesRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final TVSeries = await supabase
      .from('tv_series')
      .select();
    return sendOk(TVSeries);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final mediaId = int.parse(queryParams['query'] ?? '');
    final TVSeries = await supabase
      .from('tv_series')
      .select()
      .eq('mediaid', mediaId)
      .single();
    return sendOk(TVSeries);
  });

  router.get('/<id>', (Request req, String id) async {
    final TVSeries = await supabase
      .from('tv_series')
      .select()
      .eq('id', id)
      .single();
    return sendOk(TVSeries);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;

    discardFromBody(body, fields:
      [
        'id',
        'url',
        'artworks',
        'genres',
        'coverimage',
        'icon',
        'status',
      ]
    );
    populateBody(body, defaultFields:
      {
        'creators': [],
        'publishers': [],
        'platforms': [],
        'links': [],
        'retailers': [],
        'seriesname': [],
        'series': [],
      },
    );

    body['mediatype'] = 'tv_series';
    final specificBodies = splitBody(body, mediaType: 'tv_series');
    final result = await createFromBody(specificBodies, supabase, mediaType: 'tv_series', mediaTypePlural: 'tv_series');
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

    final TVSeries = await supabase
      .from('tv_series')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(TVSeries);
  });

  // This is intended, because we don't want to delete any tv series for caching
  router.delete('/<id>', (Request req, String id) async {
    return sendNoContent();
  });

  return router;
}
