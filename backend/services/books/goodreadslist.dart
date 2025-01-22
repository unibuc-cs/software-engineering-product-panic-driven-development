import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:puppeteer/puppeteer.dart';
import 'package:html/parser.dart' show parse;

class GoodReadsList extends Provider {
  // Members
  late final Map<String, String> _headers;

  // Private constructor
  GoodReadsList._() {
    _headers = {
      'User-Agent': config.goodreadsAgents
    };
  }

  // Singleton instance
  static final GoodReadsList _instance = GoodReadsList._();

  // Accessor for the singleton instance
  static GoodReadsList get instance => _instance;

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

  Future<Map<String, dynamic>> _getBookList(String userId) async {
    try {
      final document = await _getDocument('https://www.goodreads.com/review/list/${userId}?shelf=currently-reading');

      if (document == Document.html('')) {
        return {
          'books': []
        };
      }

      final books = <String>[];
      final rows = document.querySelectorAll('tr.bookalike.review');
      for (final row in rows) {
        final titleElement = row.querySelector('td.field.title div.value a');

        if (titleElement != null) {
          final title = titleElement.text.split('\n')[1].trim();
          books.add(title);
        }
      }
      return {
        'books': books
      };
    }
    catch (e) {
      return {
        'books': []
      };
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String bookName) async {
    return [];
  }

  @override
  Future<Map<String, dynamic>> getInfo(String userId) async {
    return instance._getBookList(userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String bookUrl) async {
    return [];
  }
}