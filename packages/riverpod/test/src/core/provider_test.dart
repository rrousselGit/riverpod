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
  });
}
