import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  group('DesktopAnnouncer', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopAnnouncer(
            child: const Text('Hello'),
          ),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('wraps child in Semantics widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopAnnouncer(
            announcement: 'Test message',
            child: const Text('Content'),
          ),
        ),
      );
      final semantics = tester.widget<Semantics>(
        find.byType(Semantics).last,
      );
      expect(semantics.properties.liveRegion, true);
      expect(semantics.properties.label, 'Test message');
    });

    testWidgets('updates announcement when prop changes', (tester) async {
      final key = GlobalKey<State>();
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopAnnouncer(
            key: key,
            announcement: 'First message',
            child: const Text('Content'),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DesktopAnnouncer(
            key: key,
            announcement: 'Second message',
            child: const Text('Content'),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Second message',
        ),
        findsOneWidget,
      );
    });

    testWidgets('without announcement still renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopAnnouncer(
            child: const Text('Content'),
          ),
        ),
      );
      expect(find.text('Content'), findsOneWidget);
    });
  });

  group('DesktopAnnouncementBanner', () {
    testWidgets('show creates overlay entry', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        DesktopAnnouncementBanner.show(
                          context,
                          message: 'Test announcement',
                          duration: const Duration(milliseconds: 100),
                        );
                      },
                      child: const Text('Show'),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Test announcement',
        ),
        findsOneWidget,
      );

      // Advance past the banner duration to let the timer fire
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
    });
  });
}
