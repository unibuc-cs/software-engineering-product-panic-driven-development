import 'Models/tag.dart';
import 'Helpers/database.dart';
import 'Services/tag_service.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final tagService = TagService();
  await seedData();

  await tagService.hydrate();
  print("-----------");
  print("Before add");
  print("-----------");
  tagService.items.forEach((tag) => print("${tag.name} ${tag.id}"));
  print("\n");

  Tag tag = await tagService.create(Tag(name: 'New Tag'));
  print("-----------");
  print("After add | Before update");
  print("-----------");
  tagService.items.forEach((tag) => print("${tag.name} ${tag.id}"));
  print("\n");

  await tagService.update(tag.id, { 'name': 'Updated Tag' });
  print("-----------");
  print("After update | Before delete");
  print("-----------");
  tagService.items.forEach((tag) => print("${tag.name} ${tag.id}"));
  print("\n");

  await tagService.delete(tag.id);
  print("-----------");
  print("After delete");
  print("-----------");
  tagService.items.forEach((tag) => print("${tag.name} ${tag.id}"));
  print("\n");
}
