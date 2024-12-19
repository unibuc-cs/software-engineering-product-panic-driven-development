import '../Models/book.dart';
import 'general/service.dart';

class BookService extends Service<Book> {
  BookService() : super(
    resource: 'books',
    fromJson: (json) => Book.from(json),
    toJson  : (book) => book.toJson(),
  );
}
