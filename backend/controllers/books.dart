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
    dynamic body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        "id",
      ]
    );
    validateBody(body, fields:
      [
        "mediaid",
        "originallanguage",
        "totalpages",
      ]
    );

    await _supabase
      .from('media')
      .select()
      .eq('id', body["mediaid"])
      .eq('mediatype', "book")
      .single();

    final book = await _supabase
      .from('book')
      .insert(body)
      .select()
      .single();
    return sendCreated(book);
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
