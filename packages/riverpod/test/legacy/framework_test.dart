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
  // TODO flushing inside mayHaveChanged calls onChanged only after all mayHaveChanged were executed

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

  test('test two families one overriden the other not', () {
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

  group('notify listeners', () {
    // test('calls onChange at most once per flush', () {
    //   final counter = Counter();
    //   final provider = StateNotifierProvider<Counter, int>((_) => counter);
    //   final container = createContainer();
    //   final mayHaveChanged = MockMarkMayHaveChanged();
    //   final listener = ListenerMock();

    //   final sub = provider.addLazyListener(
    //     container,
    //     mayHaveChanged: mayHaveChanged,
    //     onChange: listener,
    //   );

    //   verify(listener(0)).called(1);
    //   verifyNoMoreInteractions(mayHaveChanged);
    //   verifyNoMoreInteractions(listener);

    //   sub.flush();

    //   verifyNoMoreInteractions(mayHaveChanged);
    //   verifyNoMoreInteractions(listener);

    //   counter.increment();

    //   verify(mayHaveChanged()).called(1);
    //   verifyNoMoreInteractions(mayHaveChanged);
    //   verifyNoMoreInteractions(listener);

    //   counter.increment();

    //   verifyNoMoreInteractions(mayHaveChanged);
    //   verifyNoMoreInteractions(listener);

    //   sub.flush();

    //   verify(listener(2)).called(1);
    //   verifyNoMoreInteractions(mayHaveChanged);
    //   verifyNoMoreInteractions(listener);

    //   counter.increment();

    //   verify(mayHaveChanged()).called(1);
    //   verifyNoMoreInteractions(mayHaveChanged);
    //   verifyNoMoreInteractions(listener);
    // });

    // test('noop if no provider was "dirty"', () {
    //   final counter = Counter();
    //   final provider = StateNotifierProvider<Counter, int>((_) => counter);
    //   final container = createContainer();
    //   final mayHaveChanged = MockMarkMayHaveChanged();
    //   final listener = ListenerMock();

    //   final sub = provider.addLazyListener(
    //     container,
    //     mayHaveChanged: mayHaveChanged,
    //     onChange: listener,
    //   );

    //   verify(listener(0)).called(1);
    //   verifyNoMoreInteractions(listener);

    //   sub.flush();
    //   verifyNoMoreInteractions(listener);

    //   counter..increment()..increment();

    //   verifyNoMoreInteractions(listener);

    //   sub.flush();

    //   verify(listener(2)).called(1);
    //   verifyNoMoreInteractions(listener);

    //   sub.flush();

    //   verifyNoMoreInteractions(listener);
    // });

    // test('on update`', () async {
    //   final container = createContainer();
    //   final counter = Counter();
    //   final provider = StateNotifierProvider<Counter, int>((_) => counter);
    //   final mayHaveChanged = MockMarkMayHaveChanged();
    //   final listener = ListenerMock();

    //   final sub = provider.addLazyListener(
    //     container,
    //     mayHaveChanged: mayHaveChanged,
    //     onChange: listener,
    //   );

    //   verify(listener(0)).called(1);
    //   verifyNoMoreInteractions(listener);

    //   counter.increment();
    //   verifyNoMoreInteractions(listener);

    //   counter.increment();
    //   verifyNoMoreInteractions(listener);

    //   sub.flush();

    //   verify(listener(2)).called(1);
    //   verifyNoMoreInteractions(listener);
    // });

    // test('in dependency order', () async {
    //   final container = createContainer();
    //   final counter = Counter();
    //   final counter2 = Counter();
    //   final counter3 = Counter();

    //   final sprovider = StateNotifierProvider<Counter, int>((_) => counter);
    //   final sprovider2 = StateNotifierProvider<Counter, int>((ref) {
    //     ref.watch(sprovider);
    //     return counter2;
    //   });
    //   final sprovider3 = StateNotifierProvider<Counter, int>((ref) {
    //     ref.watch(sprovider2);
    //     return counter3;
    //   });

    //   // using Provider because StateNotifierProvider synchronously calls its listeners
    //   final provider = Provider<int>((ref) => ref.watch(sprovider));
    //   final provider2 = Provider<int>((ref) => ref.watch(sprovider2));
    //   final provider3 = Provider<int>((ref) => ref.watch(sprovider3));

    //   final mayHaveChanged = MockMarkMayHaveChanged();
    //   final listener = ListenerMock('first');
    //   final sub = provider.addLazyListener(
    //     container,
    //     mayHaveChanged: mayHaveChanged,
    //     onChange: listener,
    //   );

    //   final mayHaveChanged2 = MockMarkMayHaveChanged();
    //   final listener2 = ListenerMock('second');
    //   final sub2 = provider2.addLazyListener(
    //     container,
    //     mayHaveChanged: mayHaveChanged2,
    //     onChange: listener2,
    //   );

    //   final mayHaveChanged3 = MockMarkMayHaveChanged();
    //   final listener3 = ListenerMock('third');
    //   final sub3 = provider3.addLazyListener(
    //     container,
    //     mayHaveChanged: mayHaveChanged3,
    //     onChange: listener3,
    //   );

    //   verify(listener(0)).called(1);
    //   verifyNoMoreInteractions(listener);
    //   verify(listener2(0)).called(1);
    //   verifyNoMoreInteractions(listener2);
    //   verify(listener3(0)).called(1);
    //   verifyNoMoreInteractions(listener3);

    //   counter3.increment();
    //   counter2.increment();
    //   counter.increment();

    //   verifyInOrder([
    //     mayHaveChanged3(),
    //     mayHaveChanged2(),
    //     mayHaveChanged(),
    //   ]);

    //   sub3.flush();

    //   verify(listener3(1)).called(1);
    //   verifyNoMoreInteractions(listener);
    //   verifyNoMoreInteractions(listener2);
    //   verifyNoMoreInteractions(listener3);

    //   sub2.flush();
    //   verify(listener2(1)).called(1);
    //   verifyNoMoreInteractions(listener);
    //   verifyNoMoreInteractions(listener2);
    //   verifyNoMoreInteractions(listener3);

    //   sub.flush();
    //   verify(listener(1)).called(1);
    //   verifyNoMoreInteractions(listener);
    //   verifyNoMoreInteractions(listener2);
    //   verifyNoMoreInteractions(listener3);
    // });
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
