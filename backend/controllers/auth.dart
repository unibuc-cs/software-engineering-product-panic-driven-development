import '../helpers/requests.dart';
import '../helpers/responses.dart';
import '../helpers/db_connection.dart';
import 'package:supabase/supabase.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

RouterPlus authRouter() {
    final router = Router().plus;
    SupabaseClient supabase = SupabaseClientSingleton.client;

    router.post('/login', (Request req) async {
        final body = await req.body.asJson;
        validateBody(body, fields:
            [
                'email',
                'password'
            ]
        );

        await supabase.auth.signInWithPassword(
            email: body['email'],
            password: body['password']
        );

        final jwt = JWT(
            {
                'id': supabase.auth.currentUser?.id
            },
            issuer: 'MediaMaster',
        );
        final token = jwt.sign(SecretKey('secret'));
        return sendOk({ 'token': token });
    });

    router.post('/signup', (Request req) async {
        final body = await req.body.asJson;
        validateBody(body, fields:
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
        SupabaseClientSingleton.resetClient();
        supabase = SupabaseClientSingleton.client;
        return sendNoContent();
    });

    return router;
}
