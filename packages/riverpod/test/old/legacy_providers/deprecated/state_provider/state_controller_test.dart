import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('StateController', () {
    test('update allows changing the state from the previous state', () {
      final controller = StateController(0);
      addTearDown(controller.dispose);

      expect(controller.state, 0);

      final result = controller.update((state) => state + 1);

      expect(result, 1);
      expect(controller.state, 1);
    });
  });
}
