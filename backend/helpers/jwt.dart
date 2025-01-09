import 'config.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String getToken(String? userId) {
    final jwt = JWT(
        {
            'id': userId,
        },
        issuer: 'MediaMaster',
    );
    return jwt.sign(SecretKey(Config().secret));
}

Map<String, dynamic> getPayload(String token) {
    return JWT.verify(token, SecretKey(Config().secret)).payload;
}
