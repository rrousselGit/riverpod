import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../src/matrix.dart';
import '../src/utils.dart';

void main() {
  test(
    'Catches sync circular dependency when the dependency is not yet mounted',
    () {
      // regression for #1766
      final container = ProviderContainer.test();

      final c = Provider((ref) => ref);

      final a = Provider<int>((ref) {
        ref.watch(c);
        return 0;
      });

      final b = Provider<int>((ref) {
        return ref.watch(a);
      });

      container.read(a);
      final ref = container.read(c);

      expect(() => ref.read(b), throwsA(isA<CircularDependencyError>()));
    },
  );

  test('rebuilding a provider can modify other providers', () async {
    final dep = StateProvider((ref) => 0);
    final provider = Provider((ref) => ref.watch(dep));
    final another = NotifierProvider<Notifier<int>, int>(
      () => DeferredNotifier((ref, self) {
        ref.listen(provider, (prev, value) => self.state++);
        return 0;
      }),
    );
    final container = ProviderContainer.test();

    expect(container.read(another), 0);

    container.read(dep.notifier).state = 42;

    expect(container.read(another), 1);
  });

  group('ref.watch cannot end-up in a circular dependency', () {
    test('direct dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final container = ProviderContainer.test();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);

      ref.watch(provider2);
      expect(
        () => ref2.watch(provider),
        throwsA(isA<CircularDependencyError>()),
      );
    });

    test('indirect dependency', () {
      final provider = Provider(name: 'provider', (ref) => ref);
      final provider2 = Provider(name: 'provider2', (ref) => ref);
      final provider3 = Provider(name: 'provider3', (ref) => ref);
      final provider4 = Provider(name: 'provider4', (ref) => ref);
      final container = ProviderContainer.test();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);
      final ref3 = container.read(provider3);
      final ref4 = container.read(provider4);

      ref.watch(provider2);
      ref2.watch(provider3);
      ref3.watch(provider4);

      expect(
        () => ref4.watch(provider),
        throwsA(
          isA<CircularDependencyError>().having((e) => e.loop, 'loop', [
            provider,
            provider4,
            provider3,
            provider2,
            provider,
          ]),
        ),
      );
    });
  });

  group('ref.listen cannot end-up in a circular dependency', () {
    test('direct dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);

      ref.watch(provider2);
      expect(
        () => ref2.listen(provider, (a, b) {}),
        throwsA(isA<CircularDependencyError>()),
      );
    });

    test('indirect dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final provider3 = Provider((ref) => ref);
      final provider4 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);
      final ref3 = container.read(provider3);
      final ref4 = container.read(provider4);

      ref.listen(provider2, (a, b) {});
      ref2.listen(provider3, (a, b) {});
      ref3.listen(provider4, (a, b) {});

      expect(
        () => ref4.listen(provider, (a, b) {}),
        throwsA(isA<CircularDependencyError>()),
      );
    });
  });

  group('ref.read cannot end-up in a circular dependency', () {
    test('direct dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);

      ref.watch(provider2);
      expect(
        () => ref2.read(provider),
        throwsA(isA<CircularDependencyError>()),
      );
    });
    test('indirect dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final provider3 = Provider((ref) => ref);
      final provider4 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);
      final ref3 = container.read(provider3);
      final ref4 = container.read(provider4);

      ref.watch(provider2);
      ref2.watch(provider3);
      ref3.watch(provider4);

      expect(
        () => ref4.read(provider),
        throwsA(isA<CircularDependencyError>()),
      );
    });
  });

  test("initState can't dirty ancestors", () {
    final container = ProviderContainer.test();
    final ancestor = StateProvider((_) => 0);
    final child = Provider((ref) {
      ref.watch(ancestor.notifier).state++;
      return ref.watch(ancestor);
    });

    expect(errorsOf(() => container.read(child)), isNotEmpty);
  });

  test("initState can't dirty siblings", () {
    final container = ProviderContainer.test();
    final ancestor = StateProvider((_) => 0, name: 'ancestor');
    final counter = Counter();
    final sibling = StateNotifierProvider<Counter, int>(name: 'sibling', (ref) {
      ref.watch(ancestor);
      return counter;
    });
    var didWatchAncestor = false;
    final child = Provider(name: 'child', (ref) {
      ref.watch(ancestor);
      didWatchAncestor = true;
      counter.increment();
    });

    container.read(sibling);

    expect(errorsOf(() => container.read(child)), isNotEmpty);
    expect(didWatchAncestor, true);
  });

  test("initState can't mark dirty other provider", () {
    final container = ProviderContainer.test();
    final provider = StateProvider((ref) => 0);
    final provider2 = Provider((ref) {
      ref.watch(provider.notifier).state = 42;
      return 0;
    });

    expect(container.read(provider), 0);

    expect(errorsOf(() => container.read(provider2)), isNotEmpty);
  });

  test("nested initState can't mark dirty other providers", () {
    final container = ProviderContainer.test();
    final counter = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => counter);
    final nested = Provider((_) => 0);
    final provider2 = Provider((ref) {
      ref.watch(nested);
      counter.increment();
      return 0;
    });

    expect(container.read(provider), 0);

    expect(errorsOf(() => container.read(provider2)), isNotEmpty);
  });

  test('auto dispose can dirty providers', () async {
    final container = ProviderContainer.test();
    final counter = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => counter);
    var didDispose = false;
    final provider2 = Provider.autoDispose((ref) {
      ref.onDispose(() {
        didDispose = true;
        counter.increment();
      });
    });

    container.read(provider);

    final sub = container.listen<void>(provider2, (_, _) {});
    sub.close();

    expect(counter.state, 0);

    await container.pump();

    expect(didDispose, true);
    expect(counter.state, 1);
  });

  test("Provider can't dirty anything on create", () {
    final container = ProviderContainer.test();
    final counter = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => counter);
    late List<Object> errors;
    final computed = Provider((ref) {
      errors = errorsOf(counter.increment);
      return 0;
    });
    final listener = Listener<int>();

    expect(container.read(provider), 0);

    container.listen(computed, listener.call, fireImmediately: true);

    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(errors, isNotEmpty);
  });
}
