import 'package:riverpod/riverpod.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../utils.dart';

void main() {
  group('ProviderElement.approximatedDepth', () {
    test('is synchronously updated on synchronous build', () {
      final container = createContainer();
      final a = Provider((ref) => 0);
      final b = Provider((ref) => ref.watch(a));
      final c = Provider((ref) {
        ref.listen(b, (value) {});
      });

      expect(container.readProviderElement(a).approximatedDepth, 0);
      expect(container.readProviderElement(b).approximatedDepth, 1);
      expect(container.readProviderElement(c).approximatedDepth, 2);
    });

    test('is updated asynchronously on ancestor depth changes', () async {
      final container = createContainer();

      final a = StateProvider((ref) => 0, name: 'a');
      final b = Provider((ref) => 0, name: 'b');
      final c = Provider((ref) => ref.watch(b), name: 'c');
      final d = Provider((ref) => ref.watch(c), name: 'd');

      final dElement = container.readProviderElement(d);
      final cElement = container.readProviderElement(c);
      expect(cElement.approximatedDepth, 1);

      final bElement = container.readProviderElement(b);
      bElement.watch(a);

      expect(bElement.approximatedDepth, 2);
      expect(bElement.isScheduledForRedepth, true);
      expect(cElement.approximatedDepth, 1);
      expect(cElement.isScheduledForRedepth, false);
      expect(dElement.approximatedDepth, 2);
      expect(dElement.isScheduledForRedepth, false);

      container.read(a).state++;
      await container.pump();

      expect(bElement.approximatedDepth, 2);
      expect(bElement.isScheduledForRedepth, false);
      expect(cElement.approximatedDepth, 3);
      expect(cElement.isScheduledForRedepth, false);
      expect(dElement.approximatedDepth, 4);
      expect(dElement.isScheduledForRedepth, false);
    });
  });

  group('ProviderElement.isScheduledForRedepth', () {
    test(
        'is false after depth change if not scheduled to disposed/rebuild and has no listener',
        () {
      final container = createContainer();
      final a = Provider((ref) => 0);
      final b = Provider((ref) => ref.watch(a));

      container.read(b);
      expect(container.readProviderElement(b).isScheduledForRedepth, false);
    });

    test('is true after depth change if has provider listeners', () {
      final container = createContainer();
      final a = Provider((ref) => 0);
      final b = Provider((ref) => a);
      final c = Provider((ref) {
        ref.listen(b, (value) {});
      });

      container.read(c);

      final bElement = container.readProviderElement(b);
      expect(bElement.isScheduledForRedepth, false);
      bElement.watch(a);
      expect(bElement.isScheduledForRedepth, true);
    });

    test('is true after depth change if has provider dependents', () {
      final container = createContainer();
      final a = Provider((ref) => 0);
      final b = Provider((ref) => a);
      final c = Provider((ref) {
        ref.watch(b);
      });

      container.read(c);

      final bElement = container.readProviderElement(b);
      expect(bElement.isScheduledForRedepth, false);
      bElement.watch(a);
      expect(bElement.isScheduledForRedepth, true);
    });

    test('is false after depth change if has container listeners', () {
      final container = createContainer();
      final a = Provider((ref) => 0);
      final b = Provider((ref) => a);

      container.listen(b, (value) {});

      final bElement = container.readProviderElement(b);
      expect(bElement.isScheduledForRedepth, false);
      bElement.watch(a);
      expect(bElement.isScheduledForRedepth, false);
    });

    // TODO should ref.read cause a redepth?
  });
}
