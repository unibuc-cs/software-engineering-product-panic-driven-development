import 'dart:async';
import 'dart:convert';
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

  // Private methods
  Future<List<Map<String, dynamic>>> _getBooks(String bookName) async {
    try {
      final url = "https://www.goodreads.com/search?q=$bookName";
      final response = await http.get(Uri.parse(url), headers: _bookHeaders);

      if (response.statusCode == 200) {
        final document = parse(response.body);

        var options = <Map<String, dynamic>>[];
        for (var book in document.querySelectorAll("tr[itemtype='http://schema.org/Book']")) {
          final titleElement = book.querySelector("a.bookTitle");

          if (titleElement != null) {
            options.add({
              "name": titleElement.text.split("(")[0].trim(),
              "link": "https://www.goodreads.com${book.querySelector('a.bookTitle')?.attributes['href'] ?? ''}",
            });
          }
        }
        return options;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _searchBook(String bookLink) async {
    try {
      final response = await http.get(Uri.parse(bookLink), headers: _bookHeaders);

      if (response.statusCode == 200) {
        final document = parse(response.body);
        final scriptTag = document.querySelector("script[type='application/ld+json']");
        final jsonData = json.decode(scriptTag?.text ?? "{}");
        final pagesFormat = document.querySelector("p[data-testid='pagesFormat']");
        final titleSectionDiv = document.querySelector("div.BookPageTitleSection__title");
        final h3Element = titleSectionDiv?.querySelector("h3");

        return {
          "name": document.querySelector("h1.Text__title1")?.text.trim(),
          "author": document.querySelector("span.ContributorLink__name")?.text.trim(),
          "link": bookLink,
          "rating": document.querySelector("div.RatingStatistics__rating")?.text.trim(),
          "pages": pagesFormat?.text.trim().split(" ")[0],
          "release_date": document
              .querySelector("p[data-testid='publicationInfo']")
              ?.text
              .trim()
              .split("First published ")
              .last,
          "description": document.querySelector("span.Formatted")?.text.trim(),
          "book_format": jsonData["bookFormat"],
          "language": jsonData["inLanguage"],
          "series": h3Element?.querySelectorAll("a").map((a) => a.text.split("#")[0].trim()).toList() ?? [],
        };
      } else {
        return {};
      }
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
