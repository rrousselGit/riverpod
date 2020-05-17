import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('disposes the notifier when provider is unmounted', () {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final owner = ProviderStateOwner();

    expect(provider.readOwner(owner).mounted, isTrue);

    owner.dispose();

    expect(provider.readOwner(owner).mounted, isFalse);
  });

  test('provider subscribe the callback is never', () {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final listener = ControllerListenerMock();
    final owner = ProviderStateOwner();

    final sub = provider.subscribe(owner, (read) => listener(read()));

    expect(sub.read(), isA<TestNotifier>());
    verifyNoMoreInteractions(listener);

    sub.read().increment();

    verifyNoMoreInteractions(listener);

    owner.dispose();

    verifyNoMoreInteractions(listener);
  });
  test('provider subscribe callback never called', () {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final listener = ListenerMock();
    final owner = ProviderStateOwner();

    final sub = provider.value.subscribe(owner, (read) => listener(read()));

    expect(sub.read(), 0);
    verifyNoMoreInteractions(listener);

    provider.readOwner(owner).increment();

    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();

    verifyNoMoreInteractions(listener);
  });
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier() : super(0);

  void increment() => state++;
}

class ListenerMock extends Mock {
  void call(int value);
}

class ControllerListenerMock extends Mock {
  void call(TestNotifier value);
}
