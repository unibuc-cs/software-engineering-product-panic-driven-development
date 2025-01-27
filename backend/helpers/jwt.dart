import 'config.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

SecretKey get secretKey => SecretKey(Config.instance.secret);

String getToken(String? userId) => JWT
    (
      {
        'id': userId,
      },
      issuer: 'MediaMaster',
    ).sign(secretKey);

Map<String, dynamic> getPayload(String token) =>
    JWT.verify(token, secretKey).payload;
