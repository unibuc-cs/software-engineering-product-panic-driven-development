import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../general/Service.dart';

class GoodReads extends Service {
  // Members
  late final _bookHeaders;

  // Private constructor
  GoodReads._() {
    _bookHeaders = {
      "User-Agent": env["USER_AGENTS_GOODREADS"] ?? ""
    };
  }

  // Singleton instance
  static final GoodReads _instance = GoodReads._();

  // Accessor for the singleton instance
  static GoodReads get instance => _instance;

  Future<List<Map<String, dynamic>>> _getBooksFromSeries(String seriesUrl) async {
    try {
      final response = await http.get(Uri.parse(seriesUrl));

      if (response.statusCode != 200) {
        return [];
      }

      final document = parse(response.body);
      final books = await Future.wait(document.querySelectorAll('div.listWithDividers__item').map((element) async {
        return {
          "name": element.querySelector('span[itemprop="name"]')?.text.trim() ?? 'Unknown Title',
          "index": element.querySelector('h3[class="gr-h3 gr-h3--noBottomMargin"]')?.text.split("Book")[1].trim()
        };
      }).toList());

      // Remove books sets (for example, Book 1-7)
      return books.where((book) => !(book["index"]?.contains("-") ?? false)).toList();
    } catch (e) {
      return [];
    }
  }

  // Private methods
  Future<List<Map<String, dynamic>>> _getBooks(String bookName) async {
    try {
      final response = await http.get(
        Uri.parse("https://www.goodreads.com/search?q=$bookName"), 
        headers: _bookHeaders
      );

      if (response.statusCode != 200) {
        return [];
      }

      return parse(response.body)
             .querySelectorAll("tr[itemtype='http://schema.org/Book']")
             .map((book) {
                final titleElement = book.querySelector("a.bookTitle");
                if (titleElement != null) {
                  return {
                    "name": titleElement.text.split("(")[0].trim(),
                    "link": "https://www.goodreads.com${book.querySelector('a.bookTitle')?.attributes['href'] ?? ''}"
                  };
                }
              })
             .whereType<Map<String, dynamic>>()
             .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _searchBook(String bookLink) async {
    try {
      final response = await http.get(Uri.parse(bookLink), headers: _bookHeaders);

      if (response.statusCode != 200) {
        return {};
      }

      final document = parse(response.body);
      final jsonData = json.decode(document.querySelector("script[type='application/ld+json']")?.text ?? "{}");
      final seriesElement = document.querySelector("div.BookPageTitleSection__title")?.querySelector("h3");

      // Date example: July 21, 2007
      final releaseDate = document.querySelector("p[data-testid='publicationInfo']")
                                  ?.text.trim().split("First published ").last ?? "";
      final parsedDate = DateFormat("MMMM d, y").parse(releaseDate);

      return {
        "name": document.querySelector("h1.Text__title1")?.text.trim(),
        "author": document.querySelector("span.ContributorLink__name")?.text.trim(),
        "link": bookLink,
        "rating": document.querySelector("div.RatingStatistics__rating")?.text.trim(),
        "release_date": DateFormat("yyyy-MM-dd").format(parsedDate),
        "description": document.querySelector("span.Formatted")?.text.trim(),
        "pages": jsonData["numberOfPages"],
        "cover": jsonData["image"],
        "book_format": jsonData["bookFormat"],
        "language": jsonData["inLanguage"],
        "series": seriesElement?.querySelectorAll("a").map((a) => a.text.split("#")[0].trim()).toList() ?? [],
        "series_books": await instance._getBooksFromSeries(seriesElement?.querySelector("a")?.attributes['href'] ?? "")
      };
    } catch (e) {
      return {};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String bookName) async {
    return instance._getBooks(bookName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String bookLink) async {
    return instance._searchBook(bookLink);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int bookId) async {
    return [];
  }
}
