import 'dart:convert';
import '../helpers/utils.dart';
import 'package:shelf/shelf.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_router/shelf_router.dart';

Router publishersRouter() {
  final router = Router();
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final publishers = await _supabase
      .from('publisher')
      .select();
    return sendOk(publishers);
  });

  router.get('/<id>', (Request req, String id) async {
    final publisher = await _supabase
      .from('publisher')
      .select()
      .eq('id', id)
      .single();
    return sendOk(publisher);
  });

  router.post('/', (Request req) async {
    final body = jsonDecode(await req.readAsString());
    validate(body, fields:
      [
        "name"
      ]
    );

    final publisher = await _supabase
      .from('publisher')
      .insert(body)
      .select()
      .single();
    return sendCreated(publisher);
  });

  router.put('/<id>', (Request req, String id) async {
    final body = jsonDecode(await req.readAsString());
    validate(body);

    final publisher = await _supabase
      .from('publisher')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(publisher);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('publisher')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
