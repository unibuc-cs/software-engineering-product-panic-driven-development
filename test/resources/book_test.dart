import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/book.dart';
import 'package:mediamaster/Services/book_service.dart';

void main() async {

  final dummy = {
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
    ]
  };
  Book updated = Book(
    mediaId: 10,
    language: 'romanian',
    totalPages: 10,
    format: 'hardcover',
  );

  await runService(
    service    : BookService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
