import 'package:mockito/mockito.dart';
import 'package:riverpod/src/framework/framework.dart'
    show AlwaysAliveProvider;
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  test('is AlwaysAliveProvider', () {
    final provider = SetStateProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProvider>());
  });
  test('SetStateProviderContext can read and write state', () {
    final owner = ProviderStateOwner();
    SetStateProviderContext<int> providerContext;
    int initialValue;
    final provider = SetStateProvider<int>((context) {
      initialValue = context.state;
      providerContext = context;
      return 0;
    });
    final listener = ListenerMock();

    provider.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(initialValue, null);
    expect(providerContext.state, 0);

    providerContext.state++;

    expect(providerContext.state, 1);
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
  test('watchOwner', () {
    final owner = ProviderStateOwner();
    SetStateProviderContext<int> providerContext;
    final provider = SetStateProvider<int>((context) {
      providerContext = context;
      return 0;
    });
    final listener = ListenerMock();

    final removeListener = provider.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();

    providerContext.state++;

    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
  test('combining', () {
    final owner = ProviderStateOwner();
    SetStateProviderContext<int> providerContext;
    final provider = SetStateProvider<int>((context) {
      providerContext = context;
      return 1;
    });

    final combining = SetStateProvider<int>((context) {
      final first = context.dependOn(provider);
      int result;
      first.watch((value) {
        context.state = result = value * 2;
      });
      return result;
    });

    final owner2 = ProviderStateOwner(
      parent: owner,
      overrides: [combining.overrideForSubtree(combining)],
    );

    final listener = ListenerMock();

    combining.watchOwner(owner2, listener);

    verify(listener(2)).called(1);
    verifyNoMoreInteractions(listener);

    providerContext.state++;

    verify(listener(4)).called(1);
    verifyNoMoreInteractions(listener);

    owner2.dispose();

    providerContext.state++;
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
}

class ListenerMock extends Mock {
  void call(int value);
}
