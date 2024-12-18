import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/book.dart';
import '../../lib/Services/book_service.dart';

void main() async {
  Book dummyBook = Book(
    mediaId: 8,
    language: "english",
    totalPages: 100,
    format: "paperback",
  );
  Book updatedDummyBook = Book(
    mediaId: 10,
    language: "romanian",
    totalPages: 10,
    format: "hardcover",
  );

  await runService(
    BookService(),
    dummyBook,
    updatedDummyBook,
    (book) => book.toSupa()
  );
}
