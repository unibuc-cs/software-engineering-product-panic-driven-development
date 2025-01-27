import '../helpers/jwt.dart';
import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db.dart';
import 'package:supabase/supabase.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:supabase/supabase.dart';

RouterPlus authRouter() {
  final router = Router().plus;
  SupabaseClient supabase = SupabaseManager.client;

  Future<User?> getUser(Request req) async => 
    (await supabase.auth.admin.getUserById(req.context['userId']! as String)).user;

  router.get('/details', (Request req) async {
    final user = await getUser(req);
    return {
      'id'  : user!.id,
      'name': user.userMetadata?['name'],
    };
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

  router.post('/login-google', (Request req) async {
    final authUrl = supabase.auth.getOAuthSignInUrl(
      provider: OAuthProvider.google,
    );
    return sendOk({'authUrl': authUrl});
  });

  router.post('/callback-google', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields: ['token']);
    final token = body['token'];

    final response = await supabase.auth.signInWithIdToken(
      idToken: token,
      provider: OAuthProvider.google,
    );

    if (response.session == null) {
      return sendBadRequest({'error': 'Authentication failed'});
    }

    final user = response.session?.user;

    return sendOk({
      'id': user?.id,
      'email': user?.email,
      'name': user?.userMetadata?['name'],
      'token': response.session?.accessToken,
    });
  });



  router.post('/signup', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields:
      [
        'email',
        'password',
        'name',
        'isGuest',
      ]
    );

    // There is an issue with supabase.auth.signUp
    // We use the supabase admin for now as a workaround
    final response = await supabase.auth.admin.createUser(AdminUserAttributes(
      email: body['email'],
      password: body['password'],
      userMetadata: {'name': body['name'], 'isGuest': body['isGuest']},
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
