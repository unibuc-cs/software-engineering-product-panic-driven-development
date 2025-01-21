import '../helpers/jwt.dart';
import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db.dart';
import 'package:supabase/supabase.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus authRouter() {
  final router = Router().plus;
  SupabaseClient supabase = SupabaseManager.client;

  router.get('/details', (Request req) async =>
    sendOk(supabase.auth.currentUser)
  );

  router.post('/login', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields:
      [
        'email',
        'password'
      ]
    );

    await supabase.auth.signInWithPassword(
      email: body['email'],
      password: body['password']
    );
    return sendOk({ 'token': getToken(supabase.auth.currentUser?.id) });
  });

  router.post('/signup', (Request req) async {
    final body = await req.body.asJson;
    validateFromBody(body, fields:
      [
        'email',
        'password',
        'name',
      ]
    );

    // There is an issue with supabase.auth.signUp
    // We use the supabase admin for now as a workaround
    final response = await supabase.auth.admin.createUser(AdminUserAttributes(
      email: body['email'],
      password: body['password'],
      userMetadata: {'name': body['name']},
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
    await supabase.auth.signOut();
    SupabaseManager.resetClient();
    supabase = SupabaseManager.client;
    return sendNoContent();
  });

  return router;
}
