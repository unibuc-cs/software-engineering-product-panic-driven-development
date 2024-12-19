import '../general/run_tests.dart';

void main() {
  runTests(
    excluded: [
      "providers_test",
      "steam_test"
    ],
  );
}
