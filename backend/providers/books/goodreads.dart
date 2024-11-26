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
  late final _headers;

  // Private constructor
  GoodReads._() {
    _headers = {
      "User-Agent": config.goodreads_agents
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
        return Document.html("");
      }

      return parse(response.body);
    }
    catch (e) {
      return Document.html("");
    }
  }

  Future<List<Map<String, dynamic>>> _getBookOptions(String bookName) async {
    try {
      final document = await _getDocument("https://www.goodreads.com/search?q=$bookName");

      if (document == Document.html("")) {
        return [{"error": "No books found"}];
      }

      return document
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
         // Remove the nulls that appear when the if from above is false
         .whereType<Map<String, dynamic>>()
         .toList();
    }
    catch (e) {
      return [{"error": e.toString()}];
    }
  }

  Future<List> _getBooksFromSeries(String seriesUrl) async {
    try {
      final document = await _getDocument(seriesUrl);

      if (document == Document.html("")) {
        return [];
      }

      return (
        await Future.wait(
          document
          .querySelectorAll('div.listWithDividers__item')
          .map((element) async {
              return {
                "name": element.querySelector('span[itemprop="name"]')?.text.trim() ?? 'Unknown Title',
                "index": element.querySelector('h3[class="gr-h3 gr-h3--noBottomMargin"]')?.text.split("Book")[1].trim()
              };
            })
        )
      )
      .where((book) => !(book["index"]?.contains("-") ?? false))
      .toList();
    }
    catch (e) {
      return [];
    }
  }


  Future<Map<String, dynamic>> _getBookInfo(String bookUrl) async {
    try {
      final document = await _getDocument(bookUrl);

      if (document == Document.html("")) {
        return {"error": "No books found"};
      }

      final jsonData = json.decode(document.querySelector("script[type='application/ld+json']")?.text ?? "{}");
      final seriesElement = document.querySelector("div.BookPageTitleSection__title")?.querySelector("h3");

      // Date example: July 21, 2007
      final releaseDate = document.querySelector("p[data-testid='publicationInfo']")?.text
                                  .trim().split("First published ").last ?? "";
      final parsedDate = DateFormat("MMMM d, y").parse(releaseDate);

      final genres = document.querySelectorAll("span.BookPageMetadataSection__genreButton a")
        .map((element) => element.text.trim())
        .toList();

      return {
        "name": document.querySelector("h1.Text__title1")?.text.trim(),
        "author": document.querySelector("span.ContributorLink__name")?.text.trim(),
        "link": bookUrl,
        "rating": document.querySelector("div.RatingStatistics__rating")?.text.trim(),
        "release_date": DateFormat("yyyy-MM-dd").format(parsedDate),
        "description": document.querySelector("span.Formatted")?.text.trim(),
        "pages": jsonData["numberOfPages"],
        "cover": jsonData["image"],
        "genres": genres,
        "book_format": jsonData["bookFormat"],
        "language": jsonData["inLanguage"],
        "series": seriesElement?.querySelectorAll("a").map((a) => a.text.split("#")[0].trim()).toList() ?? [],
        "series_books": await instance._getBooksFromSeries(seriesElement?.querySelector("a")?.attributes['href'] ?? "")
      };
    }
    catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<List<Map<String, String>>> _getBookRecommendations(String bookUrl) async {
    final browser = await puppeteer.launch(
      headless: true,
      args: [
        '--no-sandbox',
        '--disable-gpu',
        '--disable-software-rasterizer',
        '--no-zygote',
        '--disable-extensions'
        '--disable-background-timer-throttling',
      ]
    );

    try {
      final page = await browser.newPage();

      await page.goto(bookUrl, wait: Until.networkIdle);
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

      await browser.close();

      return (recommendedBooks as List)
        .map((book) => {
          'title': book['title'] as String,
          'link': book['link'] as String,
        })
        .where((book) => book['title'] != 'No title' && book['link'] != 'No link')
        .toList();
    }
    catch (e) {
      return [{"error": e.toString()}];
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
  Future<Map<String, dynamic>> getInfo(String bookUrl) async {
    return instance._getBookInfo(bookUrl);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String bookUrl) async {
    return instance._getBookRecommendations(bookUrl);
  }

  @override
  String getKey() {
    return "link";
  }
}
