import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/book.dart';
import '../../lib/Services/book_service.dart';

void main() async {
  Book dummyBook = Book(
    mediaId: 8,
    originalLanguage: "english",
    totalPages: 100,
  );
  Book updatedDummyBook = Book(
    mediaId: 10,
    originalLanguage: "english",
    totalPages: 100,
  );

  await runService(
    BookService(),
    dummyBook,
    updatedDummyBook,
    (book) => book.toSupa()
  );
}
