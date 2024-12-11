import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../helpers/db_connection.dart';
import '../helpers/serialization.dart';
import 'package:shelf_router/shelf_router.dart';

Router linksRouter() {
  final router = Router();
  final _supabase = SupabaseClientSingleton.client;

  router.get('/', (Request req) async {
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

  router.get('/<id>', (Request req, String id) async {
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

  router.post('/', (Request req) async {
    try {
      final body = jsonDecode(await req.readAsString());

      // Check if body is complete
      List<String> keys = ["name","href"];
      for (var key in keys) {
        if (body[key] == null) {
          return Response.badRequest(body: "$key is required");
        }
      }

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

  router.put('/<id>', (Request req, String id) async {
    try {
      final body = jsonDecode(await req.readAsString());
      final link = await _supabase
        .from('link')
        .update(body)
        .eq('id', id)
        .select()
        .single();
      return mapToJson(link);
    }
    catch (e) {
      return Response.badRequest(body: e);
    }
  });

  router.delete('/<id>', (Request req, String id) async {
    try {
      await _supabase
        .from('link')
        .delete()
        .eq('id', id);
      return Response(204);
    }
    catch(e) {
      return Response.badRequest(body: e);
    }
  });

  return router;
}
