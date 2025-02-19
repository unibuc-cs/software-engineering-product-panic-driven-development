import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:puppeteer/puppeteer.dart';
import 'package:html/parser.dart' show parse;

class GoodReads extends Provider {
  // Members
  late final Map<String, String> _headers;

  // Private constructor
  GoodReads._() {
    _headers = {
      'User-Agent': config.goodreadsAgents
    };
  }

  // Singleton instance
  static final GoodReads _instance = GoodReads._();

  // Accessor for the singleton instance
  static GoodReads get instance => _instance;

  // Private methods
  Future<Document> _getDocument(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        return Document.html('');
      }

      return parse(response.body);
    }
    catch (e) {
      return Document.html('');
    }
  }

  Future<List<Map<String, dynamic>>> _getBookOptions(String bookName) async {
    try {
      final document = await _getDocument('https://www.goodreads.com/search?q=$bookName');

      if (document == Document.html('')) {
        return [{'error': 'No books found'}];
      }

      return document
         .querySelectorAll('tr[itemtype="http://schema.org/Book"]')
         .map((book) {
            final titleElement = book.querySelector('a.bookTitle');
            final releaseDate = book
              .querySelector('span.uitext')
              ?.text
              .trim()
              .split('—')
              .elementAtOrNull(2)
              ?.split('published')
              .elementAtOrNull(1)
              ?.trim() ?? '';
            if (titleElement != null) {
              return {
                'id'  : book.querySelector('a.bookTitle')?.attributes['href']?.replaceAll('/book/show/', '') ?? '',
                'name': titleElement.text.split('(')[0].trim() + (releaseDate.isNotEmpty ? ' (${releaseDate})' : ''),
              };
            }
          })
         // Remove the nulls that appear when the if from above is false
         .whereType<Map<String, dynamic>>()
         .toList();
    }
    catch (e) {
      return [{'error': e.toString()}];
    }
  }

  Future<List> _getBooksFromSeries(String seriesUrl) async {
    try {
      final document = await _getDocument(seriesUrl);

      if (document == Document.html('')) {
        return [];
      }

      return (
        await Future.wait(
          document
          .querySelectorAll('div.listWithDividers__item')
          .map((element) async {
              return {
                'name' : element.querySelector('span[itemprop="name"]')?.text.trim() ?? 'Unknown Title',
                'index': element.querySelector('h3[class="gr-h3 gr-h3--noBottomMargin"]')?.text.split('Book')[1].trim()
              };
            })
        )
      )
      .where((book) => !(book['index']?.contains('-') ?? false))
      .toList();
    }
    catch (e) {
      return [];
    }
  }


  Future<Map<String, dynamic>> _getBookInfo(String bookId) async {
    try {
      final bookUrl = 'https://www.goodreads.com/book/show/$bookId';
      final document = await _getDocument(bookUrl);

      if (document == Document.html('')) {
        return {'error': 'No books found'};
      }

      final jsonData = json.decode(document.querySelector('script[type="application/ld+json"]')?.text ?? '{}');
      final seriesElement = document.querySelector('div.BookPageTitleSection__title')?.querySelector('h3');

      // Date example: July 21, 2007
      final releaseDate = document.querySelector('p[data-testid="publicationInfo"]')?.text
                                  .trim().split('First published ').last ?? '';
      final parsedDate = DateFormat('MMMM d, y').parse(releaseDate);

      final genres = document.querySelectorAll('span.BookPageMetadataSection__genreButton a')
        .map((element) => element.text.trim())
        .toList();

      return {
        'originalname'  : document.querySelector('h1.Text__title1')?.text.trim(),
        'creators'      : [document.querySelector('span.ContributorLink__name')?.text.trim()],
        'links'         : [{
                            'name': 'Goodreads',
                            'href': bookUrl,
                          }],
        'communityscore': (double.parse(document.querySelector('div.RatingStatistics__rating')!.text.trim()) * 20).round().toString(),
        'releasedate'   : DateFormat('yyyy-MM-dd').format(parsedDate),
        'description'   : document.querySelector('span.Formatted')?.text.trim(),
        'totalpages'    : jsonData['numberOfPages'],
        'coverimage'    : jsonData['image'],
        'genres'        : genres,
        'format'        : jsonData['bookFormat'],
        'language'      : jsonData['inLanguage'],
        'seriesname'    : seriesElement?.querySelectorAll('a').map((a) => a.text.split('#')[0].trim()).toList() ?? [],
        'series'        : await instance._getBooksFromSeries(seriesElement?.querySelector('a')?.attributes['href'] ?? '')
      };
    }
    catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<List<Map<String, String>>> _getBookRecommendations(String bookUrl) async {
    final browser = await puppeteer.launch(
      headless: true,
      args: [
        '--no-sandbox',
        '--disable-gpu',
        '--disable-extensions',
        '--disable-logging',
        '--disable-images',
        '--disable-fonts',
        '--disable-css',
      ],
    );

    try {
      final page = await browser.newPage();
      await page.setRequestInterception(true);
      page.onRequest.listen((request) {
        final resourceType = request.resourceType?.toString() ?? '';
        if (['image', 'stylesheet', 'font'].any((type) => resourceType.endsWith(type))) {
          request.abort();
        } else {
          request.continueRequest();
        }
      });

      await page.goto(bookUrl, wait: Until.networkIdle, timeout: Duration(milliseconds: 60000));
      await page.waitForSelector('.BookCard__clickCardTarget');

      final recommendedBooks = await page.evaluate('''
        function() {
          const books = Array.from(document.querySelectorAll('.BookCard__clickCardTarget'));
          return books.map(function(book) {
            return {
              title: book.querySelector('.BookCard__title')?.innerText || 'No title',
              link: book.href || 'No link',
            };
          });
        }
      ''');

      return (recommendedBooks as List)
          .map((book) => {
            'title': book['title'] as String,
            'link': book['link'] as String,
          })
          .where((book) => book['title'] != 'No title' && book['link'] != 'No link')
          .toList();
    }
    catch (e) {
      return [{'error': e.toString()}];
    }
    finally {
      await browser.close();
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String bookName) async {
    return instance._getBookOptions(bookName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String bookId) async {
    return instance._getBookInfo(bookId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String bookUrl) async {
    return instance._getBookRecommendations(bookUrl);
  }
}
