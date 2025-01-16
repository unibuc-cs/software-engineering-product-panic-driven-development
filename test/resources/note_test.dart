import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/note.dart';
import 'package:mediamaster/Models/media_user.dart';
import 'package:mediamaster/Services/auth_service.dart';
import 'package:mediamaster/Services/note_service.dart';
import 'package:mediamaster/Services/media_user_service.dart';

void main() async {
  final Map<String, String> dummyUser = {
      'name': 'John Doe',
      'email': 'test@gmail.com',
      'password': '123456',
    };
    try {
      await AuthService.instance.signup(
        name: dummyUser['name']!,
        email: dummyUser['email']!,
        password: dummyUser['password']!,
      );
      print('Dummy user created');
    }
    catch (e) {
      if (!e.toString().contains('a user with this email address has already been registered')) {
        print('Signup error: $e');
        return;
      }
      print('Dummy user already exists');
    }

    try {
      await AuthService.instance.login(
        email: dummyUser['email']!,
        password: dummyUser['password']!,
      );
      print('Logged in');
    }
    catch (e) {
      print('Login error: $e');
      return;
    }

  MediaUser mu = MediaUser(
    mediaId: 1,
    userId: '',
    name: 'test',
    addedDate: DateTime.now(),
    lastInteracted: DateTime.now(),
  );
  await MediaUserService.instance.create(mu);
  
  Note dummy = Note(
    mediaId: 1,
    userId: '',
    content: 'test',
    creationDate: DateTime.now(),
    modifiedDate: DateTime.now(),
  );

  Note updatedDummy = Note(
    mediaId: 2,
    userId: '',
    content: 'test1234',
    creationDate: DateTime.now(),
    modifiedDate: DateTime.now(),
  );

  await runService(
    service    : NoteService.instance,
    dummyItem  : dummy,
    updatedItem: updatedDummy,
  );

  await MediaUserService.instance.delete(mu.mediaId);
  AuthService.instance.logout();
  print('Logged out');
}
