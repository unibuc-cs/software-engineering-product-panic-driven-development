import '../Models/book.dart';
import 'general/service.dart';

class BookService extends Service<Book> {
  BookService() : super(Book.endpoint, Book.from);
}
