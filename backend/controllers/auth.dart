import '../helpers/jwt.dart';
import '../helpers/db.dart';
import '../helpers/requests.dart';
import '../helpers/responses.dart';
import 'package:supabase/supabase.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus authRouter() {
  final router = Router().plus;
  SupabaseClient supabase = SupabaseManager.client;

  Future<User?> getUser(Request req) async =>
    (await supabase.auth.admin.getUserById(req.context['userId']! as String)).user;

  router.get('/details', (Request req) async {
    final user = await getUser(req);
    if (user != null) {
      return {
        'id': user.id,
        'name': user.userMetadata?['name'],
        'email': user.email,
        'lastSignIn': user.lastSignInAt,
        'createdAt': user.createdAt,
        'photoUrl': user.userMetadata?['photoUrl'],
      };
    }
    return {'error': 'User not found'};
  });

  router.post('/login', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields:
      [
        'email',
        'password'
      ]
    );

    final user = (
      await supabase.auth.signInWithPassword(
        email: body['email'],
        password: body['password']
      )
    ).user;
    SupabaseManager.resetClient();
    supabase = SupabaseManager.client;

    return sendOk({ 'token': getToken(user?.id) });
  });

  router.post('/signup', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields:
      [
        'email',
        'password',
        'name',
        'isGuest',
        'photoUrl',
      ]
    );

    // There is an issue with supabase.auth.signUp
    // We use the supabase admin for now as a workaround
    final response = await supabase.auth.admin.createUser(AdminUserAttributes(
      email: body['email'],
      password: body['password'],
      userMetadata: {'name': body['name'], 'isGuest': body['isGuest'], 'photoUrl': body['photoUrl']},
      emailConfirm: true,
    ));
    final User? user = response.user;
    return sendCreated({
      'id': user?.id,
      'email': user?.email,
      'name': user?.userMetadata?['name'],
    });
  });

  router.get('/logout', (Request req) async {
    final user = await getUser(req);
    await supabase.auth.signOut();
    SupabaseManager.resetClient();
    supabase = SupabaseManager.client;

    if (user == null || !user.userMetadata!.containsKey('isGuest') || !user.userMetadata?['isGuest']) {
      return sendNoContent();
    }

    List<String> tableNames = [
      'note',
      'usertag',
      'wishlist',
      'mediauser',
      'mediausertag',
      'userachievement',
      'mediausersource',
    ];

    await Future.wait(tableNames.map((tableName) => SupabaseManager
      .client
      .from(tableName)
      .delete()
      .eq('userid', user.id)
    ));

    await supabase.auth.admin.deleteUser(user.id);
    return sendNoContent();
  });

  return router;
}
