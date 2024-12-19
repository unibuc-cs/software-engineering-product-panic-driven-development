import 'dart:core';
import '../../lib/Models/book.dart';
import '../general/resource_test.dart';
import '../../lib/Services/book_service.dart';

void main() async {
  Book dummy = Book(
    mediaId: 8,
    language: "english",
    totalPages: 100,
    format: "paperback",
  );
  Book updated = Book(
    mediaId: 10,
    language: "romanian",
    totalPages: 10,
    format: "hardcover",
  );

  await runService(
    service    : BookService(),
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
