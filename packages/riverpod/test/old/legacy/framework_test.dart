import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart'
    show CircularDependencyError, ProviderElement;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('test two families one overridden the other not', () {
    final family = Provider.family<String, int>((ref, value) {
      return '$value';
    });
    final family2 = Provider.family<String, int>(
      (ref, value) {
        return '$value 2';
      },
      dependencies: const [],
    );
    final root = ProviderContainer.test();
    final container = ProviderContainer.test(
      parent: root,
      overrides: [family2],
    );

    expect(container.read(family(0)), '0');
    expect(container.read(family2(0)), '0 2');

    expect(container.getAllProviderElements(), [
      isA<ProviderElement>().having((e) => e.origin, 'origin', family2(0)),
    ]);
    expect(root.getAllProviderElements(), [
      isA<ProviderElement>().having((e) => e.origin, 'origin', family(0)),
    ]);
  });

  test('disposing an already disposed container is no-op', () {
    final container = ProviderContainer.test();

    container.dispose();
    container.dispose();
  });

  test('Owner.read', () {
    final provider = Provider((ref) => 0);
    final provider2 = Provider((ref) => 1);
    final container = ProviderContainer.test();

    final value1 = container.read(provider);
    final value2 = container.read(provider);
    final value21 = container.read(provider2);
    final value22 = container.read(provider2);

    expect(value1, value2);
    expect(value1, 0);
    expect(value21, value22);
    expect(value21, isNot(value1));
    expect(value21, 1);
  });

  test('circular dependencies (sync)', () {
    late Provider<int> provider;

    final provider1 = Provider((ref) {
      return ref.watch(provider) + 1;
    });
    final provider2 = Provider((ref) {
      return ref.watch(provider1) + 1;
    });
    provider = Provider((ref) {
      return ref.watch(provider2) + 1;
    });

    final container = ProviderContainer.test();
    expect(
      () => container.read(provider),
      throwsA(isA<CircularDependencyError>()),
    );
  });

  test('circular dependencies (async)', () {
    late Provider<int Function()> provider;

    final provider1 = Provider((ref) {
      return () => ref.watch(provider)() + 1;
    });
    final provider2 = Provider((ref) {
      return () => ref.watch(provider1)() + 1;
    });
    provider = Provider((ref) {
      return () => ref.watch(provider2)() + 1;
    });

    final container = ProviderContainer.test();

    container.read(provider);
    container.read(provider1);
    container.read(provider2);

    expect(
      () => container.read(provider)(),
      throwsA(isA<CircularDependencyError>()),
    );
  });

  test('circular dependencies when dependencies are already mounted', () {
    late Provider<void Function()> provider;

    final provider1 = Provider((ref) {
      ref.watch(provider);
    });
    final provider2 = Provider((ref) {
      ref.watch(provider1);
    });
    provider = Provider((ref) {
      return () => ref.watch(provider2);
    });

    final container = ProviderContainer.test();

    container.read(provider);
    container.read(provider1);
    container.read(provider2);

    expect(
      () => container.read(provider)(),
      throwsA(isA<CircularDependencyError>()),
    );
  });

  test('circular dependencies #2', () {
    final container = ProviderContainer.test();

    final provider = Provider((ref) => ref);
    final provider1 = Provider((ref) => ref);
    final provider2 = Provider((ref) => ref);

    container.read(provider1).read(provider);
    container.read(provider2).read(provider1);
    final ref = container.read(provider);

    expect(
      ref.read(provider2),
      isNotNull,
    );
  });

  test('dispose providers in dependency order (simple)', () {
    final container = ProviderContainer.test();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((ref) {
      ref.onDispose(onDispose1.call);
      return 1;
    });

    final provider2 = Provider((ref) {
      final value = ref.watch(provider1);
      ref.onDispose(onDispose2.call);
      return value + 1;
    });

    final provider3 = Provider((ref) {
      final value = ref.watch(provider2);
      ref.onDispose(onDispose3.call);
      return value + 1;
    });

    expect(container.read(provider3), 3);

    container.dispose();

    verifyInOrder([
      onDispose3(),
      onDispose2(),
      onDispose1(),
    ]);
    verifyNoMoreInteractions(onDispose1);
    verifyNoMoreInteractions(onDispose2);
    verifyNoMoreInteractions(onDispose3);
  });

  test('if a provider threw on creation, onDispose still works', () {
    var callCount = 0;
    final onDispose = OnDisposeMock();
    final error = Error();
    late Ref reference;
    final provider = Provider((ref) {
      reference = ref;
      callCount++;
      ref.onDispose(onDispose.call);
      throw error;
    });
    final container = ProviderContainer.test();

    expect(() => container.read(provider), throwsA(error));
    expect(callCount, 1);

    final onDispose2 = OnDisposeMock();
    reference.onDispose(onDispose2.call);

    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    container.dispose();

    expect(callCount, 1);
    verifyInOrder([
      onDispose(),
      onDispose2(),
    ]);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);
  });
}
