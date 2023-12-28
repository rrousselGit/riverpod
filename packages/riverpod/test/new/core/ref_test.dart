import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

// TODO automatically generate this list for maintainability
final refMethodsThatDependOnProviders =
    <String, void Function(Ref ref, ProviderBase<Object?>)>{
  'watch': (ref, p) => ref.watch(p),
  'read': (ref, p) => ref.read(p),
  'listen': (ref, p) => ref.listen(p, (prev, next) {}),
  'invalidate': (ref, p) => ref.invalidate(p),
  'refresh': (ref, p) => ref.refresh(p),
};
final refMethodsThatDependOnListenables =
    <String, void Function(Ref ref, ProviderListenable<Object?>)>{
  'watch': (ref, p) => ref.watch(p),
  'read': (ref, p) => ref.read(p),
  'listen': (ref, p) => ref.listen(p, (prev, next) {}),
};
final refMethodsThatDependOnProviderOrFamilies =
    <String, void Function(Ref ref, ProviderOrFamily)>{
  'invalidate': (ref, p) => ref.invalidate(p),
};

void main() {
  group('Ref', () {
    group(
        'asserts that a provider cannot depend on a provider that is not in its dependencies:',
        () {
      for (final entry in refMethodsThatDependOnProviders.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a provider', () {
          // TODO changelog "reading a provider that is not part of its dependencies is now forbidden"
          final transitiveDep = Provider((ref) => 0, dependencies: const []);
          final dep = Provider((ref) => 0, dependencies: [transitiveDep]);
          final depFamily = Provider.family(
            (ref, id) => 0,
            dependencies: const [],
          );
          final unrelatedScoped = Provider((ref) => 0, dependencies: const []);
          final unrelatedScopedFamily = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = Provider((ref) => 0);
          final provider = Provider(
            (ref) => ref,
            dependencies: [dep, depFamily],
          );
          final family = Provider.family(
            (ref, id) => ref,
            dependencies: [dep, depFamily],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider);
          final ref2 = container.read(family(0));

          // accepts providers that are part of its dependencies
          call(ref, dep);
          call(ref2, dep);
          call(ref, depFamily(42));
          call(ref2, depFamily(42));

          // accepts non-scoped providers
          call(ref, nonScopedProvider);
          call(ref2, nonScopedProvider);

          // rejects providers that are not part of its dependencies
          expect(
            () => call(ref, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, unrelatedScopedFamily(42)),
            throwsA(isA<StateError>()),
          );
        });
      }

      for (final entry in refMethodsThatDependOnListenables.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a listenable', () async {
          // TODO changelog "reading a provider that is not part of its dependencies is now forbidden"
          final transitiveDep = FutureProvider(
            (ref) => 0,
            dependencies: const [],
          );
          final dep = FutureProvider((ref) => 0, dependencies: [transitiveDep]);
          final depFamily = FutureProvider.family(
            (ref, id) => 0,
            dependencies: const [],
          );
          final unrelatedScoped = FutureProvider(
            (ref) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = FutureProvider((ref) => 0);
          final provider = FutureProvider(
            (ref) => ref,
            dependencies: [dep, depFamily],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider).requireValue;

          // accepts providers that are part of its dependencies
          call(ref, dep.select((value) => 0));
          call(ref, dep.selectAsync((value) => 0));
          call(ref, depFamily(42).select((value) => 0));

          // accepts non-scoped providers
          call(ref, nonScopedProvider.select((value) => 0));

          // rejects providers that are not part of its dependencies
          await expectLater(
            () => call(ref, unrelatedScoped.select((value) => 0)),
            throwsA(isA<StateError>()),
          );
          await expectLater(
            () => call(ref, unrelatedScoped.selectAsync((value) => 0)),
            throwsA(isA<StateError>()),
          );
          await expectLater(
            () => call(ref, unrelatedScoped.future),
            throwsA(isA<StateError>()),
          );
        });
      }

      for (final entry in refMethodsThatDependOnProviderOrFamilies.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a family (not `family(arg)`)', () {
          final transitiveDep = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final dep = Provider.family(
            (ref, id) => 0,
            dependencies: [transitiveDep],
          );
          final unrelatedScoped = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = Provider.family((ref, i) => 0);

          final provider = Provider(
            (ref) => ref,
            dependencies: [dep],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider);

          // accepts providers that are part of its dependencies
          call(ref, dep);

          // accepts non-scoped providers
          call(ref, nonScopedProvider);

          // rejects providers that are not part of its dependencies
          expect(
            () => call(ref, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
        });
      }
    });
  });
}
