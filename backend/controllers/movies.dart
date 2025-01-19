import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus moviesRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final movies = await supabase
      .from('movie')
      .select();
    return sendOk(movies);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final mediaId = int.parse(queryParams['query'] ?? '');
    final movie = await supabase
      .from('movie')
      .select()
      .eq('mediaid', mediaId)
      .single();
    return sendOk(movie);
  });

  router.get('/<id>', (Request req, String id) async {
    final movie = await supabase
      .from('movie')
      .select()
      .eq('id', id)
      .single();
    return sendOk(movie);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;

    discardFromBody(body, fields:
      [
        'id',
        'url',
        'artworks',
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
        'genres': [],
      },
    );

    body['mediatype'] = 'movie';
    final specificBodies = splitBody(body, mediaType: 'movie');
    final result = await createFromBody(specificBodies, supabase, mediaType: 'movie', mediaTypePlural: 'movies');
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

    final movie = await supabase
      .from('movie')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(movie);
  });

  // This is intended, because we don't want to delete any movie for caching
  router.delete('/<id>', (Request req, String id) async {
    return sendNoContent();
  });

  return router;
}
