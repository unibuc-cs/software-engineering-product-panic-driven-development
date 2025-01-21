import 'requests.dart';
import 'validators.dart';
import 'db.dart';
import 'package:shelf_plus/shelf_plus.dart';

class RouterBase {
  final _router = Router().plus;
  late final SupabaseManager _manager;

  RouterPlus get router => _router;

  RouterBase(String resource): _manager = SupabaseManager(resource);
}

class RouterDefault extends RouterBase {
  RouterDefault({
    required String resource,
    bool requiresUser                     = false,
    bool isMediaType                      = false,
    String idField                        = 'id',
    String nameField                      = 'name',
    String validateForTable               = '',
    List<String> discardInCreate          = const ['id'],
    List<String> validateInCreate         = const ['name'],
    Map<String, dynamic> populateInCreate = const {},
    List<String> discardInUpdate          = const ['id'],
    bool dependencyInDelete               = true,
    bool noDelete                         = false,
  }): super(resource) {
    Map<String, dynamic> _filters(Request req, [Map<String, dynamic> filters = const {}]) => {
      ...filters,
      if (requiresUser) 'userid': req.context['userId']!,
    };

    _router.get('/', (Request req) async =>
      await _manager.read(filters: _filters(req))
    );

    _router.get('/name', (Request req) async =>
      await _manager.read(single: true, filters: _filters(req, {
        nameField: req.url.queryParameters['query'] ?? '',
      }))
    );

    _router.get('/<id>', (Request req, String id) async =>
      await _manager.read(single: true, filters: _filters(req, {
        idField: id,
      }))
    );

    _router.post('/', (Request req) async {
      final body = await req.body.asJson;
      if (requiresUser) {
        body['userid'] = req.context['userId']!;
      }

      discardFromBody(body, fields: discardInCreate);
      validateFromBody(body, fields: validateInCreate);
      populateBody(body, defaultFields: isMediaType
        ? {
            'creators'  : [],
            'publishers': [],
            'platforms' : [],
            'links'     : [],
            'retailers' : [],
            'seriesname': [],
            'series'    : [],
            'genres'    : [],
          }
        : populateInCreate
      );
      if (validateForTable.isNotEmpty) {
        await validateExistence(body[idField], validateForTable);
      }

      return isMediaType
        ? await createMediaType({
            ...body,
            'mediatype': resource,
          })
        : await _manager.create(body);
    });

    _router.put('/<id>', (Request req, String id) async {
      final body = await req.body.asJson;
      discardFromBody(body, fields: discardInUpdate);

      if (validateForTable.isNotEmpty) {
        await validateExistence(id, validateForTable);
      }

      return await _manager.update(body, filters: _filters(req, {
        idField: id,
      }));
    });

    _router.delete('/<id>', (Request req, String id) async {
      if (noDelete) {
        return await _manager.delete();
      }

      if (dependencyInDelete) {
        await SupabaseManager('media${resource}').delete(filters: {
          '${resource}id': id,
        });
      }

      return await _manager.delete(filters: _filters(req, {
        idField: id,
      }));
    });
  }
}

class RouterMedia extends RouterBase {
  RouterMedia({
    required String resource,
    bool requiresUser = false,
  }): super('media${requiresUser ? "user" : ""}${resource}') {
    Future<void> _validate(Map<String, dynamic> body, String idField) async =>
      await Future.wait({
        'media': 'mediaid',
        idField.split('id').first: idField,
      }.entries.map((entry) async => await validateExistence(body[entry.value], entry.key)));

    Map<String, dynamic> _filters(Request req, [String mediaId = '', Map<String, dynamic> filters = const {}]) => {
      ...filters,
      if (mediaId.isNotEmpty) 'mediaid': mediaId,
      if (requiresUser) 'userid': req.context['userId']!,
    };

    final idField = '${resource}id';

    _router.get('/', (Request req) async =>
      await _manager.read(filters: _filters(req))
    );

    _router.get('/<mediaId>/<id>', (Request req, String mediaId, String id) async =>
      await _manager.read(single: true, filters: _filters(req, mediaId, {
        idField: id,
      }))
    );

    _router.post('/', (Request req) async {
      final body = await req.body.asJson;
      if (requiresUser) {
        body['userid'] = req.context['userId']!;
      }
      validateFromBody(body, fields: ['mediaid', idField]);
      await _validate(body, idField);

      return await _manager.create(body);
    });

    _router.put('/<mediaId>/<id>', (Request req, String mediaId, String id) async {
      final body = await req.body.asJson;
      await _validate(body, idField);

      return await _manager.update(body, filters: _filters(req, mediaId, {
        idField: id,
      }));
    });

    _router.delete('/<mediaId>/<id>', (Request req, String mediaId, String id) async =>
      await _manager.delete(filters: _filters(req, mediaId, {
        idField: id,
      }))
    );
  }
}
