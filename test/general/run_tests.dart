import 'dart:io';
import 'package:path/path.dart';
import '../../backend/helpers/utils.dart';

String extractName(String path) {
  return path.substring(path.lastIndexOf('\\') + 1, path.length - 11);
}

void runTests({
  List<String>? excluded
}) {
  excluded ??= [];
  excluded.add('run_tests');
  List<String> last = ['anime', 'book', 'game', 'manga', 'movie', 'tv_series'];
  var files = Directory(Platform.script.toFilePath())
    .parent
    .listSync()
    .where((entity) => entity is File && entity.path.endsWith('.dart'))
    .where((file) => !last.contains(extractName(file.toString())))
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