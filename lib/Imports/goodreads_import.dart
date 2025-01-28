import '../Models/book.dart';
import '../Services/provider_service.dart';
import 'provider_import.dart';

ProviderImport<Book> get goodreadsImport => ProviderImport<Book>(
  listProvider: getBooksList,
  optionsProvider: getOptionsBook,
  providerName: 'Goodreads',
  howToGetIdLink: 'https://help.goodreads.com/s/article/Where-can-I-find-my-user-ID',
);
