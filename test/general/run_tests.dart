import 'dart:io';
import 'package:path/path.dart';
import '../../backend/helpers/utils.dart';

void runTests({
  required List<String> excluded
}) {
  final files = Directory(Platform.script.toFilePath())
    .parent
    .listSync()
    .where((entity) => entity is File && entity.path.endsWith('.dart'))
    .toList();
  final dashes = greenColored('-' * 35);
  for (var file in files) {
    bool skip = false;
    excluded.forEach((word) {
      if (file.path.contains(word)) {
        skip = true;
      }
    });
    if (skip) {
      continue;
    }
    print(' $dashes');
    print('${greenColored('${padEnd('| Running ${basename(file.path)}', 36)}|')}');
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
    print('${blueColored('~' * 70)}\n');
  }
}