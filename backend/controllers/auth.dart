import '../helpers/jwt.dart';
import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db.dart';
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
      //print("User Data: ${user.toJson()}");
      //print(user.createdAt);
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

  router.get('/users/<userId>', (Request req, String userId) async {
    final user = await getUser(req);  
    final response = await supabase.auth.admin.getUserById(userId);
    final userData = response.user;

    if (userData != null) {
      //print(userData);
      return {
        'id': userData.id,
        'name': userData.userMetadata?['name'],
        'photoUrl': userData.userMetadata?['photoUrl'],
        'email': userData.email,
        'lastSignIn': userData.lastSignInAt,
        'createdAt': userData.createdAt,
      };
    }
    return {'error': 'User not found'};
  });

  router.get('/users', (Request req) async {
    final response = await supabase.auth.admin.listUsers();

    final users = response.map((user) => { 
      'id': user.id,
      'name': user.userMetadata?['name'] ?? 'Unknown',
      'email': user.email,
    }).toList();

    return users;
  });

  router.post('/updateUser', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields: ['name', 'photoUrl']);

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
    } catch (e) {
      return {'error': 'Failed to update metadata: $e'};
    }
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

    // Guest account, so we have to delete everything related to it
    List<String> tableNames = [
      'note',
      'wishlist',
      'mediauser',
      'mediausertag',
      'userachievement',
      //TODO: add these
      //'usertag',
      //'mediausersource',
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
