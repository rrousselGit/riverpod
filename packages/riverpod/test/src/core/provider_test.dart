import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderBase', () {
    test('allTransitiveDependencies', () {
      final a = Provider((ref) => 0);
      final b = Provider.family((ref, _) => 0, dependencies: [a]);
      final c = Provider((ref) => 0, dependencies: [b]);
      final d = Provider((ref) => 0, dependencies: [c]);

      expect(d.$allTransitiveDependencies, containsAll(<Object>[a, b, c]));

      expect(b.$allTransitiveDependencies, isNotNull);
      expect(b.dependencies, isNotNull);
      expect(b(21).$allTransitiveDependencies, isNull);
      expect(b(21).dependencies, isNull);
    });

    group('addListener', () {
      test('throws if specifying both weak and fireImmediately', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);

        expect(
          () => container.listen(
            provider,
            (previous, value) {},
            weak: true,
            fireImmediately: true,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('ref.isPaused', () {
      test('isPaused always starts as false', () {
        final container = ProviderContainer.test();

        final a = Provider((ref) => ref.isPaused);
        final b = Provider((ref) => ref.isPaused);

        expect(container.read(a), isFalse);
        expect(container.listen(b, (_, _) {}).read(), isFalse);
      });

      test('isPaused follows ProviderSubscription.pause/resume', () {
        final container = ProviderContainer.test();

        final a = Provider((ref) => ref);

        final sub = container.listen(a, (_, _) {});

        sub.pause();
        expect(sub.read().isPaused, isTrue);

        sub.resume();
        expect(sub.read().isPaused, isFalse);
      });

      test('isPaused follows listener count', () {
        final container = ProviderContainer.test();

        final a = Provider((ref) => ref);

        final sub = container.listen(a, (_, _) {});
        final ref = sub.read();

        expect(ref.isPaused, isFalse);

        sub.close();

        expect(ref.isPaused, isTrue);
      });
    });
  });
}
