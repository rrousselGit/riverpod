import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('implicit provider.state override works on children owner too', () {
    final notifier = TestNotifier(42);
    final provider = StateNotifierProvider((_) => TestNotifier());
    final root = ProviderStateOwner();
    final root2 = ProviderStateOwner(
      parent: root,
      overrides: [provider.overrideAs(StateNotifierProvider((_) => notifier))],
    );
    final owner = ProviderStateOwner(parent: root2);

    expect(provider.readOwner(owner), notifier);
    expect(provider.state.readOwner(owner), 42);
  });
  test('overriding the provider overrides provider.state too', () {
    final notifier = TestNotifier(42);
    final provider = StateNotifierProvider((_) => TestNotifier());
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(
      parent: root,
      overrides: [
        provider.overrideAs(StateNotifierProvider((_) => TestNotifier(10)))
      ],
    );

    // does not crash
    owner.updateOverrides([
      provider.overrideAs(StateNotifierProvider((_) => notifier)),
    ]);

    expect(provider.readOwner(owner), notifier);
    expect(provider.state.readOwner(owner), 42);

    notifier.increment();

    expect(provider.state.readOwner(owner), 43);
  });
  test('can specify name', () {
    final provider = StateNotifierProvider(
      (_) => TestNotifier(),
      name: 'example',
    );

    expect(provider.name, 'example');
    expect(provider.state.name, 'example.state');

    final provider2 = StateNotifierProvider((_) => TestNotifier());

    expect(provider2.name, isNull);
    expect(provider2.state.name, isNull);
  });
  test('disposes the notifier when provider is unmounted', () {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier>((_) {
      return notifier;
    });
    final owner = ProviderStateOwner();

    expect(provider.readOwner(owner), notifier);
    expect(notifier.mounted, isTrue);

    owner.dispose();

    expect(notifier.mounted, isFalse);
  });

  test('provider subscribe the callback is never', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier>((_) {
      return notifier;
    });
    final listener = ControllerListenerMock();
    final owner = ProviderStateOwner();

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
    final provider = StateNotifierProvider<TestNotifier>((_) {
      return TestNotifier();
    });
    final listener = ListenerMock();
    final owner = ProviderStateOwner();

    final sub = provider.state.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );
    verify(listener(argThat(equals(0)))).called(1);
    verifyNoMoreInteractions(listener);

    provider.readOwner(owner).increment();

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

class ListenerMock extends Mock {
  void call(int value);
}

class ControllerListenerMock extends Mock {
  void call(TestNotifier value);
}
