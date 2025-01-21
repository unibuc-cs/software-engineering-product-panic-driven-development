import 'config.dart';
import 'responses.dart';
import 'package:supabase/supabase.dart';
import 'package:shelf_plus/shelf_plus.dart';

class SupabaseManager {
  static SupabaseClient _client = SupabaseClient(
    Config.instance.supabaseUrl,
    Config.instance.supabaseServiceKey,
  );
  late SupabaseQueryBuilder _tableQuery;

  SupabaseManager(String resource): _tableQuery = _client.from(resource);

  static SupabaseClient get client => _client;

  static void resetClient() {
    _client = SupabaseClient(
      Config.instance.supabaseUrl,
      Config.instance.supabaseServiceKey,
    );
  }

  dynamic _addFilters(dynamic query, Map<String, dynamic> filters) {
    filters.forEach((key, value) {
      query = key == 'name'
        ? query.ilike(key, value)
        : query.eq(key, value);
    });
    return query;
  }

  Future<Response> read({bool single = false, Map<String, dynamic> filters = const {}}) async {
    final result = await _addFilters(_tableQuery.select(), filters);
    return sendOk(single ? result.first : result);
  }

  Future<Response> create(Map<String, dynamic> body) async =>
    sendCreated(await _tableQuery.insert(body).select().single());

  Future<Response> update(Map<String, dynamic> body, {required Map<String, dynamic> filters}) async =>
    sendOk(await _addFilters(_tableQuery.update(body), filters).select().single());

  Future<Response> delete({Map<String, dynamic> filters = const {}}) async {
    if (filters.isNotEmpty) {
      await _addFilters(_tableQuery.delete(), filters);
    }
    return sendNoContent();
  }
}
