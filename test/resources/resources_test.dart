import '../general/run_tests.dart';

void main() {
  runTests(
    excluded: [
      "generic_test",
      "resources_test"
    ],
  );
}
