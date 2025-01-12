import 'package:mediamaster/Models/media_user.dart';
import 'package:mediamaster/Services/auth_service.dart';
import 'package:mediamaster/Services/media_user_service.dart';

import 'Models/tag.dart';
import 'Models/book.dart';
import 'Helpers/database.dart';
import 'Services/tag_service.dart';
import 'Services/book_service.dart';
import 'Services/media_service.dart';

void main() async {
  final tagService = TagService.instance;
  final bookService = BookService.instance;
  final mediaService = MediaService.instance;
  final mediaUserService = MediaUserService.instance;
  await seedData();

  final authService = AuthService.instance;
  
  final Map<String, String> dummyUser = {
    'name': 'John Doe',
    'email': 'test@gmail.com',
    'password': '123456',
  };
  try {
    await authService.signup(
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
    await authService.login(
      email: dummyUser['email']!,
      password: dummyUser['password']!,
    );
    print('Logged in');
  }
  catch (e) {
    print('Login error: $e');
    return;
  }

  print(await AuthService.instance.details());

  await bookService.hydrate();
  await mediaService.hydrate();
  print('-----------');
  print('Before add');
  print('-----------');
  print('Books');
  print(bookService.items.length);
  bookService.items.forEach((book) => print('${book.language} ${book.id}'));
  print('Media');
  print(mediaService.items.length);
  print('\n');

  Book book = await bookService.create({
    'originalname': 'The Well of Ascension',
    'creators': ['Andreiiiiii'],
    'platforms': ['PS7'],
    'publishers': ['Andreeeeea'],
    'links': ['https://www.goodreads.com/book/show/68429.The_Well_of_Ascension?from_search=true'],
    'retailers': [
      'test'
    ],
    'releasedate': '2017-02-24 00:00:00.000',
    'criticscore': '75',
    'communityscore': '88',
    'description': 'it bestows.',
    'totalpages': 590,
    // 'coverimage': 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1619538925i/68429.jpg',
    'genres': [
      'Fantasy',
      'Fiction',
      'High Fantasy',
      'Epic Fantasy',
      'Audiobook',
      'Adult',
      'Magic'
    ],
    'format': 'Hardcover',
    'language': 'English',
    'seriesname': [
      'The Mistborn Saga'
    ],
    'series': [
      {
        'name': 'The Eleventh Metal',
        'index': '0.5'
      },
      {
        'name': 'Mistborn: The Final Empire',
        'index': '1'
      },
      {
        'name': 'The Well of Ascension',
        'index': '2'
      }
    ]});
  print('-----------');
  print('After add | Before update');
  print('-----------');
  print('Books');
  print(bookService.items.length);
  bookService.items.forEach((book) => print('${book.language} ${book.id}'));
  print('Media');
  print(mediaService.items.length);
  print('\n');

  await bookService.update(book.id, { 'language': 'romanian' });
  print('-----------');
  print('After update | Before delete');
  print('-----------');
  print('Books');
  print(bookService.items.length);
  bookService.items.forEach((book) => print('${book.language} ${book.id}'));
  print('Media');
  print(mediaService.items.length);
  print('\n');

  await bookService.delete(book.id);
  print('-----------');
  print('After delete');
  print('-----------');
  print('Books');
  bookService.items.forEach((book) => print('${book.language} ${book.id}'));
  print(bookService.items.length);
  print('\n');

  await tagService.hydrate();
  print('-----------');
  print('Before add');
  print('-----------');
  tagService.items.forEach((tag) => print('${tag.name} ${tag.id}'));
  print('\n');

  Tag tag = await tagService.create(Tag(name: 'New Tag'));
  print('-----------');
  print('After add | Before update');
  print('-----------');
  tagService.items.forEach((tag) => print('${tag.name} ${tag.id}'));
  print('\n');

  await tagService.update(tag.id, { 'name': 'Updated Tag' });
  print('-----------');
  print('After update | Before delete');
  print('-----------');
  tagService.items.forEach((tag) => print('${tag.name} ${tag.id}'));
  print('\n');

  await tagService.delete(tag.id);
  print('-----------');
  print('After delete');
  print('-----------');
  tagService.items.forEach((tag) => print('${tag.name} ${tag.id}'));
  print('\n');

  // MediaUser Test
  await mediaUserService.hydrate();
  print('-----------');
  print('Before add');
  print('-----------');
  mediaUserService.items.forEach((mu) => print('${mu.mediaId} ${mu.userId} ${mu.name}'));
  print('\n');

  MediaUser dummy = await mediaUserService.create(
    MediaUser(
      mediaId: 1,
      userId: '6f61eb81-444a-4956-ac97-f81113cb12cc',
      name: 'asdfghjkl',
      addedDate: DateTime.now(),
      lastInteracted: DateTime.now(),
    )
  );
  print('-----------');
  print('After add | Before update');
  print('-----------');
  mediaUserService.items.forEach((mu) => print('${mu.mediaId} ${mu.userId} ${mu.name}'));
  print('\n');

  await mediaUserService.update(dummy.mediaId, { 'name': 'Updated MU' });
  print('-----------');
  print('After update | Before delete');
  print('-----------');
  mediaUserService.items.forEach((mu) => print('${mu.mediaId} ${mu.userId} ${mu.name}'));
  print('\n');

  await mediaUserService.delete(dummy.mediaId);
  print('-----------');
  print('After delete');
  print('-----------');
  mediaUserService.items.forEach((mu) => print('${mu.mediaId} ${mu.userId} ${mu.name}'));
  print('\n');
  // End MediaUser test
}
