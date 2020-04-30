import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:provider/provider.dart';

void main() {
  test('SetStateProviderState can read and write state', () {
    final owner = ProviderStateOwner();
    SetStateProviderState<int> providerState;
    int initialValue;
    final provider = SetStateProvider<int>((state) {
      initialValue = state.state;
      providerState = state;
      return 0;
    });
    final listener = ListenerMock();

    provider.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(initialValue, null);
    expect(providerState.state, 0);

    providerState.state++;

    expect(providerState.state, 1);
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
  test('watchOwner', () {
    final owner = ProviderStateOwner();
    SetStateProviderState<int> providerState;
    final provider = SetStateProvider<int>((state) {
      providerState = state;
      return 0;
    });
    final listener = ListenerMock();

    final removeListener = provider.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();

    providerState.state++;

    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
  test('combining', () {
    final owner = ProviderStateOwner();
    SetStateProviderState<int> providerState;
    final provider = SetStateProvider<int>((state) {
      providerState = state;
      return 1;
    });

    final combining = SetStateProviderBuilder<int>() //
        .add(provider)
        .build((state, first) {
      int result;
      first.watch((value) {
        state.state = result = value * 2;
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

    providerState.state++;

    verify(listener(4)).called(1);
    verifyNoMoreInteractions(listener);

    owner2.dispose();

    providerState.state++;
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
}

class ListenerMock extends Mock {
  void call(int value);
}

class MySetStateProvider extends SetStateProvider<int> {
  MySetStateProvider(
    Create<int, SetStateProviderState<int>> create,
  ) : super(create);
}
