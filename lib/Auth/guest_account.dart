import 'dart:math';
import 'package:mediamaster/Services/auth_service.dart';
import 'package:mediamaster/UserSystem.dart';

String _generateRandomString() {
  var r = Random();
  int len = max(15, r.nextInt(20));
  const chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length-1)]).join();
}

enum guestCreationStage { notStarted, workingOn }

Future<void> createGuestUser() async {
  final name = 'Guest';
  final email = '$name${_generateRandomString()}@gmail.com';
  final password = _generateRandomString();

  try {
    await AuthService.instance.signup(
      name    : name,
      email   : email,
      password: password,
      isGuest : true,
    );
    await AuthService.instance.login(
      email   : email,
      password: password,
    );
    await UserSystem.instance.login();
  }
  catch (e) {
    String new_error = e.toString().split(',')[0].split('message:')[1].trim();
    throw new_error.replaceFirst(new_error[0], new_error[0].toUpperCase());
  }
}

