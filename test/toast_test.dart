import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: DesktopTheme(
          data: DesktopThemeData.light(),
          child: child,
        ),
      ),
    );
  }

  group('DesktopToast', () {
    setUp(() => DesktopToast.clearAll());
    tearDown(() => DesktopToast.clearAll());

    testWidgets('shows toast message', (tester) async {
      await tester.pumpWidget(buildTestApp(
        Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DesktopToast.show(context, message: 'Saved!');
            },
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsOneWidget);
    });

    testWidgets('shows success icon', (tester) async {
      await tester.pumpWidget(buildTestApp(
        Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DesktopToast.show(
                context,
                message: 'Done',
                type: DesktopToastType.success,
              );
            },
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('shows error icon', (tester) async {
      await tester.pumpWidget(buildTestApp(
        Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DesktopToast.show(
                context,
                message: 'Failed',
                type: DesktopToastType.error,
              );
            },
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows action button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DesktopToast.show(
                context,
                message: 'Deleted',
                actionLabel: 'Undo',
              );
            },
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('close button dismisses toast', (tester) async {
      await tester.pumpWidget(buildTestApp(
        Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DesktopToast.show(context, message: 'Close me');
            },
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Close me'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Close me'), findsNothing);
    });

    testWidgets('shows multiple toasts', (tester) async {
      await tester.pumpWidget(buildTestApp(
        Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DesktopToast.show(context, message: 'Toast 1');
              DesktopToast.show(context, message: 'Toast 2');
            },
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Toast 1'), findsOneWidget);
      expect(find.text('Toast 2'), findsOneWidget);
    });

    testWidgets('auto dismisses after duration', (tester) async {
      await tester.pumpWidget(buildTestApp(
        Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DesktopToast.show(
                context,
                message: 'Temporary',
                duration: const Duration(seconds: 3),
              );
            },
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Temporary'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.text('Temporary'), findsNothing);
    });
  });
}
