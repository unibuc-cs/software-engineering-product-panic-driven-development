import 'dart:convert';
import '../Models/link.dart';
import 'general/request.dart';
import 'package:http/http.dart' as http;

class LinkService {
  Future<Link> create(Link link) async {
    return await request<Link>(
      method  : 'POST',
      endpoint: '/links',
      body    : link.toSupa(),
      fromJson: (json) => Link.from(json),
    );
  }

  Future<List<Link>> getAll() async {
    return await request<List<Link>>(
      method  : 'GET',
      endpoint: '/links',
      fromJson: (json) => (json as List).map((data) => Link.from(data)).toList(),
    );
  }

  Future<Link> getById(int id) async {
    return await request<Link>(
      method  : 'GET',
      endpoint: '/links/$id',
      fromJson: (json) => Link.from(json),
    );
  }

  Future<Link> update(int id, Link link) async {
    return await request<Link>(
      method  : 'PUT',
      endpoint: '/links/$id',
      body    : link.toSupa(),
      fromJson: (json) => Link.from(json),
    );
  }

  Future<void> delete(int id) async {
    return await request<void>(
      method  : 'DELETE',
      endpoint: '/links/$id',
      fromJson: (_) => null,
    );
  }
}

