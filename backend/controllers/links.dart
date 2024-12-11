import 'dart:convert';
import '../helpers/utils.dart';
import 'package:shelf/shelf.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:shelf_router/shelf_router.dart';

Router linksRouter() {
  final router = Router();
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
    final links = await _supabase
      .from('link')
      .select();
    return sendOk(links);
  });

  router.get('/<id>', (Request req, String id) async {
    final link = await _supabase
      .from('link')
      .select()
      .eq('id', id)
      .single();
    return sendOk(link);
  });

  router.post('/', (Request req) async {
    final body = jsonDecode(await req.readAsString());
    validate(body, fields:
      [
        "name",
        "href"
      ]
    );

    final link = await _supabase
      .from('link')
      .insert(body)
      .select()
      .single();
    return sendCreated(link);
  });

  router.put('/<id>', (Request req, String id) async {
    final body = jsonDecode(await req.readAsString());
    validate(body);

    final link = await _supabase
      .from('link')
      .update(body)
      .eq('id', id)
      .select()
      .single();
    return sendOk(link);
  });

  router.delete('/<id>', (Request req, String id) async {
    await _supabase
      .from('link')
      .delete()
      .eq('id', id);
    return sendNoContent();
  });

  return router;
}
