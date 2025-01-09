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
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendOk(notes);
  });

  router.get('/<mediaId>', (Request req, String mediaId) async {
    final note = await supabase
      .from('note')
      .select()
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!)
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
    body['userid'] = SupabaseClientSingleton.userId;

    final note = await supabase
      .from('note')
      .insert(body)
      .select()
      .single();
    return sendCreated(note);
  });

  router.put('/<mediaId>', (Request req, String mediaId) async {
    final body = await req.body.asJson;
    discardFromBody(body, fields:
      [
        'mediaid',
        'userid',
      ]
    );

    final note = await supabase
      .from('note')
      .update(body)
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!)
      .select()
      .single();
    return sendOk(note);
  });

  router.delete('/<mediaId>', (Request req, String mediaId) async {
    await supabase
      .from('note')
      .delete()
      .eq('mediaid', mediaId)
      .eq('userid', SupabaseClientSingleton.userId!);
    return sendNoContent();
  });

  return router;
}
