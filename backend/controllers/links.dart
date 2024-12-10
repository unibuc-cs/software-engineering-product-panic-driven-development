import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../helpers/db_connection.dart';
import '../helpers/serialization.dart';
import 'package:shelf_router/shelf_router.dart';

Router linksRouter() {
  final router = Router();
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request request) async {
    try {
      final links = await _supabase
        .from('link')
        .select();
      return listToJson(links);
    }
    catch (e) {
      return Response.badRequest(body: e);
    }
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final link = await _supabase
        .from('link')
        .select()
        .eq('id', id)
        .single(); 
      return mapToJson(link);
    }
    catch (e) {
      return Response.badRequest(body: e);
    }
  });

  router.post('/', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final link = await _supabase
        .from('link')
        .insert(body)
        .select()
        .single();
      return mapToJson(link);
    }
    catch (e) {
      return Response.badRequest(body: e);
    }
  });

  return router;
}
