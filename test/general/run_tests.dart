import 'dart:io';
import 'package:path/path.dart';
import '../../backend/helpers/io.dart';
import '../../backend/helpers/utils.dart';

void runTests({
  List<String>? excluded
}) {
  excluded ??= [];
  excluded.add('run_tests');
  List<String> last = [
    'media_creator',
    'media_genre',
    'media_link',
    'media_platform',
    'media_publisher',
    'media_retailer',
    'media_series',
    'anime',
    'book',
    'game',
    'manga',
    'movie',
    'tv_series',
    'season',
    'game_achievement'
  ];
  var files = Directory(Platform.script.toFilePath())
    .parent
    .listSync()
    .where((entity) => entity is File && entity.path.endsWith('.dart'))
    .where((file) => !last.contains(extractFileName(file.toString())))
    .toList();
  files.addAll(last.map((file) => File(join(Directory(Platform.script.toFilePath()).parent.path, file + '_test.dart'))));
  final dashes = greenColored('-' * 35);
  for (var file in files) {
    bool skip = false;
    for (String word in excluded) {
      if (file.path.contains(word)) {
        skip = true;
      }
    }
    if (skip) {
      continue;
    }
    print(' $dashes');
    print(greenColored('${padEnd('| Running ${basename(file.path)}', 36)}|'));
    print(' $dashes');
    final result = Process.runSync('dart', ['--define=LOCAL=true', file.path]).stdout;
    for (var line in result.split('\n')) {
      if (line.contains('error:')) {
        print(redColored(line));
      }
      else {
        print(line);
      }
    }
    print('${greyColored('~' * 70)}\n');
  }
}