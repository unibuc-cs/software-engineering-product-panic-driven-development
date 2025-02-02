import '../helpers/db.dart';
import '../helpers/requests.dart';
import '../helpers/responses.dart';
import 'package:supabase/supabase.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus usersRouter() {
  final router = Router().plus;
  SupabaseClient supabase = SupabaseManager.client;

  Future<User?> getUser(Request req) async =>
    (await supabase.auth.admin.getUserById(req.context['userId']! as String)).user;

  Future<int> getMediaTypeCount(List<dynamic> mediaIds, String mediaType) async => (
    await supabase
      .from('media')
      .select()
      .eq('mediatype', mediaType)
      .inFilter('id', mediaIds)
    ).length;

  Future<Map<String, int>> getUserLibraryDetails(String userId) async {
    final mediaIds = (await supabase
      .from('mediauser')
      .select()
      .eq('userid', userId))
      .map((mediaUser) => mediaUser['mediaid'])
      .toList();

    List<dynamic> mediaCount = await Future.wait(
      ['anime', 'book', 'game', 'manga', 'movie', 'tv_series']
      .map((mediaType) => getMediaTypeCount(mediaIds, mediaType))
    );

    return {
      'anime'    : mediaCount[0],
      'books'    : mediaCount[1],
      'games'    : mediaCount[2],
      'manga'    : mediaCount[3],
      'movies'   : mediaCount[4],
      'tv_series': mediaCount[5],
    };
  }

  router.get('/', (Request req) async {
    final response = await supabase.auth.admin.listUsers();
    return sendOk(response.map((user) => {
      'id': user.id,
      'name': user.userMetadata?['name'] ?? 'Unknown',
      'email': user.email,
    }).toList());
  });

  router.get('/<userId>', (Request req, String userId) async {
    final response = await supabase.auth.admin.getUserById(userId);
    final userData = response.user;

    if (userData != null) {
      return {
        'id': userData.id,
        'name': userData.userMetadata?['name'],
        'photoUrl': userData.userMetadata?['photoUrl'],
        'email': userData.email,
        'lastSignIn': userData.lastSignInAt,
        'createdAt': userData.createdAt,
        'details': await getUserLibraryDetails(userId),
      };
    }
    return {'error': 'User not found'};
  });

  router.post('/update', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields: [
      'name',
      'photoUrl'
    ]);

    final user = await getUser(req);
    if (user == null) {
      return {'error': 'User not found'};
    }

    try {
      final response = await supabase.auth.admin.updateUserById(
        user.id,
        attributes: AdminUserAttributes(
          userMetadata: {
            'name': body['name'],
            'photoUrl': body['photoUrl'],
          },
        ),
      );

      final updatedUser = response.user;
      return {
        'id': updatedUser?.id,
        'name': updatedUser?.userMetadata?['name'],
        'photoUrl': updatedUser?.userMetadata?['photoUrl'],
      };
    }
    catch (e) {
      return {'error': 'Failed to update metadata: $e'};
    }
  });

  return router;
}