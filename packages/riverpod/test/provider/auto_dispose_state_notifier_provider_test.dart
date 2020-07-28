import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

import 'package:riverpod/src/internals.dart' as internals;

import '../utils.dart';

void main() {
  test('StateNotifierFamily override', () async {
    final notifier2 = TestNotifier(42);
    final provider = StateNotifierProvider.autoDispose
        .family<TestNotifier, int>((ref, a) => TestNotifier());
    final container = ProviderContainer(
      overrides: [provider.overrideWithProvider((ref, a) => notifier2)],
    );
    final ownerStateListener = Listener<int>();
    final ownerNotifierListener = Listener<TestNotifier>();

    // access in the child container
    // try to read provider.state before provider and see if it points to the override
    final ownerStateRemove =
        provider(0).state.watchOwner(container, ownerStateListener);
    verify(ownerStateListener(42)).called(1);
    verifyNoMoreInteractions(ownerStateListener);

    final ownerNotifierRemove =
        provider(0).watchOwner(container, ownerNotifierListener);
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

  test('can be assigned to Provider.autoDispose', () {
    // ignore: unused_local_variable
    final internals.AutoDisposeProvider<TestNotifier> provider =
        StateNotifierProvider.autoDispose((_) {
      return TestNotifier();
    });
  });

  test('overriding the provider overrides provider.state too', () {
    final provider = StateNotifierProvider.autoDispose((_) => TestNotifier());
    final notifier = TestNotifier(42);
    final container = ProviderContainer(
      overrides: [
        provider.overrideWithProvider(
          StateNotifierProvider.autoDispose((_) => TestNotifier(10)),
        )
      ],
    );
    final stateListener = Listener<int>();
    final notifierListener = Listener<TestNotifier>();

    // does not crash
    container.updateOverrides([
      provider.overrideWithProvider(
          StateNotifierProvider.autoDispose((_) => notifier)),
    ]);

    provider.watchOwner(container, notifierListener);
    verify(notifierListener(notifier)).called(1);
    verifyNoMoreInteractions(notifierListener);

    provider.state.watchOwner(container, stateListener);
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

    expect(provider.name, 'example');
    expect(provider.state.name, 'example.state');

    final provider2 = StateNotifierProvider.autoDispose((_) => TestNotifier());

    expect(provider2.name, isNull);
    expect(provider2.state.name, isNull);
  });

  test('disposes the notifier when provider is unmounted', () {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier>((_) {
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
    final provider = StateNotifierProvider.autoDispose<TestNotifier>((_) {
      return notifier;
    });
    final listener = ControllerListenerMock();
    final container = ProviderContainer();

    final sub = provider.addLazyListener(
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
    final provider = StateNotifierProvider.autoDispose<TestNotifier>((_) {
      return notifier;
    });
    final listener = Listener<int>();
    final container = ProviderContainer();

    final sub = provider.state.addLazyListener(
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
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier([int initialValue = 0]) : super(initialValue);

  void increment() => state++;
}

class Listener<T> extends Mock {
  void call(T value);
}

class ControllerListenerMock extends Mock {
  void call(TestNotifier value);
}
