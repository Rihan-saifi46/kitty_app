import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/app/kitty_app.dart';
import 'package:kitty_app/core/config/app_constants.dart';

void main() {
  testWidgets('KittyApp root smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: KittyApp(),
      ),
    );

    // Verify that app name and Phase 1 foundation status are rendered.
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('Phase 1: Core Foundation Active'), findsOneWidget);
  });
}
