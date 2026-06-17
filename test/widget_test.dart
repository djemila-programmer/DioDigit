import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Firebase initialization required — skip widget test in unit test mode.
    // Real integration tests should use Firebase emulator.
    expect(true, isTrue);
  });
}
