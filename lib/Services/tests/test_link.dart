import 'dart:core';
import '../link_service.dart';
import '../../Models/link.dart';

void main() async {
  final linkService = LinkService();
  int id = 0;

  try {
    final newLink = await linkService.create(Link(name: 'Example', href: 'https://example.com'));
    print('Created link: ${newLink.name}, ${newLink.href}');
    id = newLink.id;
  }
  catch (e) {
    print('Error creating link: $e');
  }

  try {
    final links = await linkService.getAll();
    print('Fetch all');
    links.forEach((link) {
      print('${link.name}: ${link.href}');
    });
  }
  catch (e) {
    print('Error fetching links: $e');
  }

  try {
    final link = await linkService.getById(id);
    print('Fetched link: ${link.name}, ${link.href}');
  }
  catch (e) {
    print('Error fetching link: $e');
  }

  try {
    final updatedLink = await linkService.update(id, Link(name: 'Updated Link', href: 'https://updated.com'));
    print('Updated link: ${updatedLink.name}, ${updatedLink.href}');
  }
  catch (e) {
    print('Error updating link: $e');
  }

  try {
    await linkService.delete(id);
    print('Link with ID $id deleted');
  }
  catch (e) {
    print('Error deleting link: $e');
  }
}
