import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus booksRouter() {
  final router = Router().plus;
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final books = await _supabase
      .from('book')
      .select();
    return sendOk(books);
  });

  router.get('/<id>', (Request req, String id) async {
    final book = await _supabase
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
        "id",
      ]
    );

    body["mediatype"] = "book";
    final specificBodies = splitBody(body, mediaType: "book");
    
    validateBody(specificBodies["bookBody"]!, fields:
      [
        "language",
        "totalpages",
        "format",
      ]
    );

    final result = await createFromBody(specificBodies, mediaType: "book");
    return sendOk(result);
  });

  router.put('/<id>', (Request req, String id) async {
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
        "mediaid",
      ]
    );

    final book = await _supabase
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
