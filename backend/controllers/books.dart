import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus booksRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final books = await supabase
      .from('book')
      .select();
    return sendOk(books);
  });

  router.get('/name', (Request req) async {
    final queryParams = req.url.queryParameters;
    final mediaId = int.parse(queryParams['query'] ?? '');
    final book = await supabase
      .from('book')
      .select()
      .eq('mediaid', mediaId)
      .single();
    return sendOk(book);
  });

  router.get('/<id>', (Request req, String id) async {
    final book = await supabase
      .from('book')
      .select()
      .eq('id', id)
      .single();
    return sendOk(book);
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

    body['mediatype'] = 'book';
    final specificBodies = splitBody(body, mediaType: 'book');
    final result = await createFromBody(specificBodies, supabase, mediaType: 'book', mediaTypePlural: 'books');
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

    final book = await supabase
      .from('book')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(book);
  });

  // This is intended, because we don't want to delete any book for caching
  router.delete('/<id>', (Request req, String id) async {
    return sendNoContent();
  });

  return router;
}
