import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus notesRouter() {
  final router = Router().plus;
  final supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final notes = await supabase
      .from('note')
      .select()
      .eq('userid', req.context['userId']!);
    return sendOk(notes);
  });

  router.get('/<id>', (Request req, String id) async {
    final note = await supabase
      .from('note')
      .select()
      .eq('id', id)
      .single();
    return sendOk(note);
  });

  router.post('/', (Request req) async {
    final body = await req.body.asJson;
    validateBody(body, fields:
      [
        'mediaid',
        'content',
        'creationdate',
        'modifieddate',
      ]
    );
    await validateExistence(body['mediaid'], 'media', supabase);
    body['userid'] = req.context['userId'];

    final note = await supabase
      .from('note')
      .insert(body)
      .select()
      .single();
    return sendCreated(note);
  });

  router.put('/<id>', (Request req, String id) async {
    final body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'id',
        'mediaid',
        'userid',
      ]
    );

    final note = await supabase
      .from('note')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(note);
  });

  router.delete('/<id>', (Request req, String id) async {
    await supabase
      .from('note')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
