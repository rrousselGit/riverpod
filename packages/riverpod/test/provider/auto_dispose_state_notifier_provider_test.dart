import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('StateNotifierFamily override', () async {
    final notifier2 = TestNotifier(42);
    final provider = StateNotifierProvider.autoDispose
        .family<TestNotifier, int, int>((ref, a) => TestNotifier());
    final container = ProviderContainer(
      overrides: [provider.overrideWithProvider((ref, a) => notifier2)],
    );
    final ownerStateListener = Listener<int>();
    final ownerNotifierListener = Listener<TestNotifier>();

    // access in the child container
    // try to read provider.state before provider and see if it points to the override
    final ownerStateRemove =
        provider(0).watchOwner(container, ownerStateListener);
    verify(ownerStateListener(42)).called(1);
    verifyNoMoreInteractions(ownerStateListener);

    final ownerNotifierRemove =
        provider(0).notifier.watchOwner(container, ownerNotifierListener);
    verify(ownerNotifierListener(notifier2)).called(1);
    verifyNoMoreInteractions(ownerNotifierListener);

    ownerNotifierRemove();

    await Future<void>.value();

    expect(notifier2.mounted, true);

    ownerStateRemove();

    expect(notifier2.mounted, true);
    await Future<void>.value();

    expect(notifier2.mounted, false);
  });

  test('overriding the provider overrides provider.state too', () {
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final container = ProviderContainer(
      overrides: [
        provider.overrideWithValue(TestNotifier(10)),
      ],
    );
    final stateListener = Listener<int>();
    final notifierListener = Listener<TestNotifier>();

    // does not crash
    container.updateOverrides([
      provider.overrideWithValue(notifier),
    ]);

    provider.notifier.watchOwner(container, notifierListener);
    verify(notifierListener(notifier)).called(1);
    verifyNoMoreInteractions(notifierListener);

    provider.watchOwner(container, stateListener);
    verify(stateListener(42)).called(1);
    verifyNoMoreInteractions(stateListener);

    notifier.increment();

    verify(stateListener(43)).called(1);
    verifyNoMoreInteractions(notifierListener);
    verifyNoMoreInteractions(stateListener);
  });

  test('can specify name', () {
    final provider = StateNotifierProvider.autoDispose(
      (_) => TestNotifier(),
      name: 'example',
    );

    expect(provider.notifier.name, 'example.notifier');
    expect(provider.name, 'example');

    final provider2 = StateNotifierProvider.autoDispose((_) => TestNotifier());

    expect(provider2.notifier.name, isNull);
    expect(provider2.name, isNull);
  });

  test('disposes the notifier when provider is unmounted', () {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return notifier;
    });
    final container = ProviderContainer();

    provider.watchOwner(container, (value) {});
    expect(notifier.mounted, isTrue);

    container.dispose();

    expect(notifier.mounted, isFalse);
  });

  test('provider subscribe the callback is never', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return notifier;
    });
    final listener = ControllerListenerMock();
    final container = ProviderContainer();

    final sub = provider.notifier.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(argThat(isA<TestNotifier>()))).called(1);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    verifyNoMoreInteractions(listener);
    sub.read();

    verifyNoMoreInteractions(listener);

    container.dispose();
    await Future.value(null);

    verifyNoMoreInteractions(listener);
  });

  test('provider subscribe callback never called', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return notifier;
    });
    final listener = Listener<int>();
    final container = ProviderContainer();

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );
    verify(listener(argThat(equals(0)))).called(1);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    verifyNoMoreInteractions(listener);
    sub.read();
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    container.dispose();
    await Future.value(null);

    verifyNoMoreInteractions(listener);
  });

  test('.notifier obtains the controller without listening to it', () {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider =
        StateNotifierProvider.autoDispose<TestNotifier, int>((ref) {
      return ref.watch(dep).state == 0 ? notifier : notifier2;
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      didChange: (_) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.increment();

    sub.flush();
    expect(callCount, 0);

    container.read(dep).state++;

    expect(sub.read(), notifier2);

    sub.flush();
    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  test('overrideWithProvider preserves the state accross update', () {
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final notifier2 = TestNotifier(21);
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider(
        StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
          return notifier;
        }),
      ),
    ]);
    addTearDown(container.dispose);
    final listener = Listener<int>();

    final sub = container.listen<int>(
      provider,
      didChange: (sub) => listener(sub.read()),
    );

    expect(sub.read(), 42);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    sub.flush();
    verifyOnly(listener, listener(43));

    container.updateOverrides([
      provider.overrideWithProvider(
        StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
          return notifier2;
        }),
      ),
    ]);

    sub.flush();
    expect(container.read(provider.notifier), notifier);
    expect(notifier2.hasListeners, false);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    sub.flush();
    expect(container.read(provider.notifier), notifier);
    verifyOnly(listener, listener(44));
    expect(notifier.mounted, true);

    container.dispose();

    expect(notifier.mounted, false);
  });
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier([int initialValue = 0]) : super(initialValue);

  void increment() => state++;
}

class Listener<T> extends Mock {
  void call(T? value);
}

class ControllerListenerMock extends Mock {
  void call(TestNotifier? value);
}
