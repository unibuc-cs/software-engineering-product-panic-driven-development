import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus gamesRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final games = await supabase
      .from('game')
      .select();
    return sendOk(games);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final mediaId = int.parse(queryParams['query'] ?? '');
    final game = await supabase
      .from('game')
      .select()
      .eq('mediaid', mediaId)
      .single();
    return sendOk(game);
  });

  router.get('/<id>', (Request req, String id) async {
    final game = await supabase
      .from('game')
      .select()
      .eq('id', id)
      .single();
    return sendOk(game);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;

    discardFromBody(body, fields:
      [
        'id',
        'url',
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

    body['mediatype'] = 'game';
    final specificBodies = splitBody(body, mediaType: 'game');
    final result = await createFromBody(specificBodies, supabase, mediaType: 'game', mediaTypePlural: 'games');
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

    final game = await supabase
      .from('game')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(game);
  });

  // This is intended, because we don't want to delete any game for caching
  router.delete('/<id>', (Request req, String id) async {
    return sendNoContent();
  });

  return router;
}
