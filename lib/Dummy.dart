import 'Models/tag.dart';
import 'Models/book.dart';
import 'Helpers/database.dart';
import 'Services/tag_service.dart';
import 'Services/book_service.dart';
import 'Services/media_service.dart';

void main() async {
  final bookService = BookService.instance;
  final mediaService = MediaService.instance;
  await seedData();
  
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

  final tagService = TagService.instance;
  await seedData();

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
}
