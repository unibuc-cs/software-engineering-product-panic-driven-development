import 'package:test/test.dart';
import '../../../lib/Services/provider_service.dart';

void main() {
  group('Goodreads', () {
    test('getOptions for several valid books', () async {
      final books = [
        'Harry Potter',
        'Maze Runner',
        'Endgame',
        'Assassin\'s Apprentice',
        'Assassin\'s Creed'
      ];
      for (var book in books) {
        final options = await getOptionsBook(book);
        expect(options, isNotEmpty);
        for (var option in options) {
          expect(option['name'], isNotEmpty);
          expect(option['link'], isNotEmpty);
        }
      }
    });

    test('getOptions for an invalid book', () async {
      final options = await getOptionsBook('asdasdasdasdasd');
      expect(options, isEmpty);
    });

    test('getInfo for a valid book', () async {
      // book: Harry Potter and the Sorcerer's Stone
      final book_info = await getInfoBook({
        'link': 'https://www.goodreads.com/book/show/42844155-harry-potter-and-the-sorcerer-s-stone?from_search=true&from_srp=true&qid=q78uVI5JCT&rank=1'
      });
      expect(book_info, isNotNull);
      expect(book_info['author'], 'J.K. Rowling');
      expect(book_info['release_date'], '1997-06-26');
      expect(book_info['series'][0], contains('Harry Potter'));
      expect(book_info['pages'], 333);
    });
  });
}
