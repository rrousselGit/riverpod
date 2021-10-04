import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

Matcher isProvider(ProviderBase provider) {
  return isA<ProviderElementBase>().having(
    (e) => e.origin,
    'provider',
    provider,
  );
}

void main() {
  test('disposing parent container when child container is not dispose throws',
      () {
    final root = createContainer();
    createContainer(parent: root);

    expect(root.dispose, throwsStateError);
  });

  test('hasListeners', () {
    final container = createContainer();
    final provider = Provider((_) => 42);

    expect(container.read(provider), 42);

    final state = container.getAllProviderElements().single;

    expect(state.hasListeners, false);

    final sub = container.listen(provider, (_) {});

    expect(state.hasListeners, true);

    sub.close();

    expect(state.hasListeners, false);
  });

  test('test two families one overridden the other not', () {
    var callCount = 0;
    final family = Provider.family<String, int>((ref, value) {
      callCount++;
      return '$value';
    });
    var callCount2 = 0;
    final family2 = Provider.family<String, int>((ref, value) {
      callCount2++;
      return '$value 2';
    });
    final container = createContainer(overrides: [
      family.overrideWithProvider(
        (value) => Provider((ref) => 'override $value'),
      ),
    ]);

    expect(container.read(family(0)), 'override 0');

    expect(callCount2, 0);
    expect(container.read(family2(0)), '0 2');
    expect(callCount2, 1);

    expect(callCount, 0);
  });

  test('changing the override type at a given index throws', () {
    final provider = Provider((ref) => 0);
    final family = Provider.family<int, int>((ref, value) => 0);
    final container = createContainer(overrides: [
      family.overrideWithProvider((value) => Provider((ref) => 0)),
    ]);

    expect(
      () => container.updateOverrides(
        [provider.overrideWithProvider(Provider((_) => 42))],
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  test('last family override is applied', () {
    final family = Provider.family<int, int>((ref, value) => 0);
    final container = createContainer(overrides: [
      family.overrideWithProvider((value) => Provider((ref) => 1)),
    ]);

    expect(container.read(family(0)), 1);

    container.updateOverrides([
      family.overrideWithProvider((value) => Provider((ref) => 2)),
    ]);

    expect(container.read(family(0)), 1);
    expect(container.read(family(1)), 2);
  });

  test("can't call onDispose inside onDispose", () {
    final provider = Provider((ref) {
      ref.onDispose(() {
        ref.onDispose(() {});
      });
      return ref;
    });
    final container = createContainer();

    container.read(provider);

    final errors = <Object>[];
    runZonedGuarded(container.dispose, (err, _) => errors.add(err));

    expect(errors, [isStateError]);
  });

  test("can't call read inside onDispose", () {
    final provider2 = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.onDispose(() {
        ref.read(provider2);
      });
      return ref;
    });
    final container = createContainer();

    container.read(provider);

    final errors = <Object>[];
    runZonedGuarded(container.dispose, (err, _) => errors.add(err));

    expect(errors, [isStateError]);
  });

  test("can't call watch inside onDispose", () {
    final provider2 = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.onDispose(() {
        ref.watch(provider2);
      });
      return ref;
    });
    final container = createContainer();

    container.read(provider);

    final errors = <Object>[];
    runZonedGuarded(container.dispose, (err, _) => errors.add(err));

    expect(errors, [isStateError]);
  });

  test('disposing an already disposed container is no-op', () {
    final container = createContainer();

    container.dispose();
    container.dispose();
  });

  test('Owner.read', () {
    final provider = Provider((ref) => 0);
    final provider2 = Provider((ref) => 1);
    final container = createContainer();

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

  test(
      "updating overrides / dispose don't compute provider states if not loaded yet",
      () {
    var callCount = 0;
    final provider = Provider((_) => callCount++);

    final container = createContainer(
      overrides: [provider.overrideWithProvider(provider)],
    );

    expect(callCount, 0);

    container.updateOverrides([
      provider.overrideWithProvider(provider),
    ]);

    expect(callCount, 0);

    container.dispose();

    expect(callCount, 0);
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

    final container = createContainer();
    expect(
      () => container.read(provider),
      throwsA(isA<ProviderException>()),
    );
  });

  test('circular dependencies (async)', () {
    late Provider<int Function()> provider;

    final provider1 = Provider((ref) {
      return ref.watch(provider)() + 1;
    });
    final provider2 = Provider((ref) {
      return ref.watch(provider1) + 1;
    });
    provider = Provider((ref) {
      return () => ref.watch(provider2) + 1;
    });

    final container = createContainer();
    expect(
      () => container.read(provider)(),
      throwsA(isA<ProviderException>()),
    );
  });

  test('circular dependencies #2', () {
    final container = createContainer();

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
    final container = createContainer();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((ref) {
      ref.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((ref) {
      final value = ref.watch(provider1);
      ref.onDispose(onDispose2);
      return value + 1;
    });

    final provider3 = Provider((ref) {
      final value = ref.watch(provider2);
      ref.onDispose(onDispose3);
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

  test('ProviderRefBase is unusable after dispose (read/onDispose)', () {
    final container = createContainer();
    late ProviderElement ref;
    final provider = Provider((s) {
      ref = s as ProviderElement;
      return 42;
    });
    final other = Provider((_) => 42);

    expect(container.read(provider), 42);
    container.dispose();

    expect(ref.mounted, isFalse);
    expect(() => ref.onDispose(() {}), throwsStateError);
    expect(() => ref.read(other), throwsStateError);
  });

  test('if a provider threw on creation, onDispose still works', () {
    var callCount = 0;
    final onDispose = OnDisposeMock();
    final error = Error();
    late ProviderRefBase reference;
    final provider = Provider((ref) {
      reference = ref;
      callCount++;
      ref.onDispose(onDispose);
      throw error;
    });
    final container = createContainer();

    expect(() => container.read(provider), throwsA(isA<ProviderException>()));
    expect(callCount, 1);

    final onDispose2 = OnDisposeMock();
    reference.onDispose(onDispose2);

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

class AsyncListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class ListenerMock extends Mock {
  ListenerMock([this.debugLabel]);
  final String? debugLabel;

  void call(int value);

  @override
  String toString() {
    if (debugLabel != null) {
      return debugLabel!;
    }
    return super.toString();
  }
}

class MockMarkMayHaveChanged extends Mock {
  void call();
}

class MockDidUpdateProvider extends Mock {
  void call();
}
