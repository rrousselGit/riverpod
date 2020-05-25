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

  test('provider subscribe the callback is never', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier;
    });
    final listener = ControllerListenerMock();
    final owner = ProviderStateOwner();

    provider.watchOwner(owner, listener);

    verify(listener(argThat(isA<TestNotifier>()))).called(1);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    verifyNoMoreInteractions(listener);
    owner.update();

    verifyNoMoreInteractions(listener);

    owner.dispose();
    await Future.value(null);

    verifyNoMoreInteractions(listener);
  });
  test('provider subscribe callback never called', () async {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final listener = ListenerMock();
    final owner = ProviderStateOwner();

    provider.value.watchOwner(owner, listener);

    verify(listener(argThat(equals(0)))).called(1);
    verifyNoMoreInteractions(listener);

    provider.readOwner(owner).increment();

    verifyNoMoreInteractions(listener);
    owner.update();
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
    await Future.value(null);

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
