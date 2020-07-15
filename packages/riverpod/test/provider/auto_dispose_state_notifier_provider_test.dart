import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

import 'package:riverpod/src/internals.dart' as internals;

void main() {
  test('StateNotifierFamily override', () async {
    final notifier = TestNotifier();
    final notifier2 = TestNotifier(42);
    final provider =
        StateNotifierProvider.autoDispose.family<TestNotifier, int>(
      (ref, a) => notifier,
    );
    final root = ProviderContainer();
    final owner = ProviderContainer(parent: root, overrides: [
      provider.overrideAs((ref, a) => notifier2),
    ]);
    final rootStateListener = Listener<int>();
    final rootNotifierListener = Listener<TestNotifier>();
    final ownerStateListener = Listener<int>();
    final ownerNotifierListener = Listener<TestNotifier>();

    // populate in the root first
    final rootStateRemove =
        provider(0).state.watchOwner(root, rootStateListener);
    verify(rootStateListener(0)).called(1);
    verifyNoMoreInteractions(rootStateListener);

    final rootNotifierRemove =
        provider(0).watchOwner(root, rootNotifierListener);
    verify(rootNotifierListener(notifier)).called(1);
    verifyNoMoreInteractions(rootNotifierListener);

    // access in the child owner
    // try to read provider.state before provider and see if it points to the override
    final ownerStateRemove =
        provider(0).state.watchOwner(owner, ownerStateListener);
    verify(ownerStateListener(42)).called(1);
    verifyNoMoreInteractions(ownerStateListener);

    final ownerNotifierRemove =
        provider(0).watchOwner(owner, ownerNotifierListener);
    verify(ownerNotifierListener(notifier2)).called(1);
    verifyNoMoreInteractions(ownerNotifierListener);

    rootStateRemove();
    ownerNotifierRemove();

    await Future<void>.value();

    expect(notifier.mounted, true);
    expect(notifier2.mounted, true);

    rootNotifierRemove();
    ownerStateRemove();

    expect(notifier.mounted, true);
    expect(notifier2.mounted, true);
    await Future<void>.value();

    expect(notifier.mounted, false);
    expect(notifier2.mounted, false);
  });
  test('can be assigned to Provider.autoDispose', () {
    // ignore: unused_local_variable
    final internals.AutoDisposeProvider<TestNotifier> provider =
        StateNotifierProvider.autoDispose((_) {
      return TestNotifier();
    });
  });
  test('implicit provider.state override works on children owner too', () {
    final notifier = TestNotifier(42);
    final provider = StateNotifierProvider.autoDispose((_) => TestNotifier());
    final root = ProviderContainer();
    final root2 = ProviderContainer(
      parent: root,
      overrides: [
        provider.overrideAs(StateNotifierProvider.autoDispose((_) => notifier))
      ],
    );
    final owner = ProviderContainer(parent: root2);
    final stateListener = Listener<int>();
    final notifierListener = Listener<TestNotifier>();

    provider.watchOwner(owner, notifierListener);
    verify(notifierListener(notifier)).called(1);
    verifyNoMoreInteractions(notifierListener);

    provider.state.watchOwner(owner, stateListener);
    verify(stateListener(42)).called(1);
    verifyNoMoreInteractions(stateListener);
  });
  test('overriding the provider overrides provider.state too', () {
    final notifier = TestNotifier(42);
    final provider = StateNotifierProvider.autoDispose((_) => TestNotifier());
    final root = ProviderContainer();
    final owner = ProviderContainer(
      parent: root,
      overrides: [
        provider.overrideAs(
            StateNotifierProvider.autoDispose((_) => TestNotifier(10)))
      ],
    );
    final stateListener = Listener<int>();
    final notifierListener = Listener<TestNotifier>();

    // does not crash
    owner.updateOverrides([
      provider.overrideAs(StateNotifierProvider.autoDispose((_) => notifier)),
    ]);

    provider.watchOwner(owner, notifierListener);
    verify(notifierListener(notifier)).called(1);
    verifyNoMoreInteractions(notifierListener);

    provider.state.watchOwner(owner, stateListener);
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
    final owner = ProviderContainer();

    provider.watchOwner(owner, (value) {});
    expect(notifier.mounted, isTrue);

    owner.dispose();

    expect(notifier.mounted, isFalse);
  });

  test('provider subscribe the callback is never', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier>((_) {
      return notifier;
    });
    final listener = ControllerListenerMock();
    final owner = ProviderContainer();

    final sub = provider.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(argThat(isA<TestNotifier>()))).called(1);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    verifyNoMoreInteractions(listener);
    sub.flush();

    verifyNoMoreInteractions(listener);

    owner.dispose();
    await Future.value(null);

    verifyNoMoreInteractions(listener);
  });
  test('provider subscribe callback never called', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier>((_) {
      return notifier;
    });
    final listener = Listener<int>();
    final owner = ProviderContainer();

    final sub = provider.state.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );
    verify(listener(argThat(equals(0)))).called(1);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    verifyNoMoreInteractions(listener);
    sub.flush();
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
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
