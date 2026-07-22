import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  group('DesktopWindowState', () {
    test('defaults have expected values', () {
      const state = DesktopWindowState.defaults;
      expect(state.x, 100);
      expect(state.y, 100);
      expect(state.width, 800);
      expect(state.height, 600);
      expect(state.isMaximized, false);
      expect(state.isMinimized, false);
      expect(state.isFullscreen, false);
    });

    test('copyWith creates modified copy', () {
      const state = DesktopWindowState.defaults;
      final modified = state.copyWith(width: 1024, height: 768);
      expect(modified.width, 1024);
      expect(modified.height, 768);
      expect(modified.x, state.x);
    });

    test('toJson produces correct map', () {
      const state = DesktopWindowState(
        x: 50,
        y: 100,
        width: 1920,
        height: 1080,
        isMaximized: true,
      );
      final json = state.toJson();
      expect(json['x'], 50);
      expect(json['y'], 100);
      expect(json['width'], 1920);
      expect(json['height'], 1080);
      expect(json['isMaximized'], true);
      expect(json['isMinimized'], false);
    });

    test('fromJson deserializes correctly', () {
      final state = DesktopWindowState.fromJson({
        'x': 200,
        'y': 300,
        'width': 1200,
        'height': 900,
        'isMaximized': true,
      });
      expect(state.x, 200);
      expect(state.y, 300);
      expect(state.width, 1200);
      expect(state.height, 900);
      expect(state.isMaximized, true);
    });

    test('fromJson handles missing fields with defaults', () {
      final state = DesktopWindowState.fromJson({});
      expect(state.x, 100);
      expect(state.y, 100);
      expect(state.width, 800);
      expect(state.height, 600);
    });

    test('toJsonString and fromJsonString roundtrip', () {
      const original = DesktopWindowState(
        x: 42,
        y: 84,
        width: 640,
        height: 480,
        isFullscreen: true,
      );
      final jsonString = original.toJsonString();
      final restored = DesktopWindowState.fromJsonString(jsonString);
      expect(restored, original);
    });

    test('equality works', () {
      const a = DesktopWindowState(x: 1, y: 2, width: 3, height: 4);
      const b = DesktopWindowState(x: 1, y: 2, width: 3, height: 4);
      const c = DesktopWindowState(x: 1, y: 2, width: 3, height: 5);
      expect(a, b);
      expect(a == c, false);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('DesktopWindowStatePersistence', () {
    test('save and load roundtrip', () async {
      final persistence = DesktopWindowStatePersistence(filePath: '/tmp/test.json');
      const state = DesktopWindowState(x: 10, y: 20, width: 500, height: 400);

      await persistence.save(state);
      final loaded = await persistence.load();

      expect(loaded, state);
    });

    test('load returns null when nothing saved', () async {
      final persistence = DesktopWindowStatePersistence(filePath: '/tmp/empty.json');
      final loaded = await persistence.load();
      expect(loaded, isNull);
    });

    test('clear removes saved state', () async {
      final persistence = DesktopWindowStatePersistence(filePath: '/tmp/clear.json');
      await persistence.save(const DesktopWindowState());
      await persistence.clear();
      final loaded = await persistence.load();
      expect(loaded, isNull);
    });
  });
}
