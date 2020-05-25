import 'package:mockito/mockito.dart';
import 'package:riverpod/src/framework/framework.dart' show AlwaysAliveProvider;
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  test('is AlwaysAliveProvider', () {
    final provider = SetStateProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProvider>());
  });
  test('SetStateProviderReference can read and write state', () {
    final owner = ProviderStateOwner();
    SetStateProviderReference<int> ref;
    int initialValue;
    final provider = SetStateProvider<int>((r) {
      initialValue = r.state;
      ref = r;
      return 0;
    });
    final listener = ListenerMock();

    provider.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(initialValue, null);
    expect(ref.state, 0);

    ref.state++;

    expect(ref.state, 1);

    verifyNoMoreInteractions(listener);
    owner.update();

    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
  test('subscribe', () {
    final owner = ProviderStateOwner();
    SetStateProviderReference<int> ref;
    final provider = SetStateProvider<int>((r) {
      ref = r;
      return 0;
    });
    final listener = ListenerMock();

    final removeListener = provider.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();

    ref.state++;

    verifyNoMoreInteractions(listener);
    owner.update();

    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
  test('combining', () {
    // final owner = ProviderStateOwner();
    // SetStateProviderReference<int> ref;
    // final provider = SetStateProvider<int>((r) {
    //   ref = r;
    //   return 1;
    // });

    // final combining = SetStateProvider<int>((ref) {
    //   final first = ref.dependOn(provider);
    //   int result;
    //   first.watch((value) {
    //     ref.state = result = value * 2;
    //   });
    //   return result;
    // });

    // final owner2 = ProviderStateOwner(
    //   parent: owner,
    //   overrides: [combining.overrideForSubtree(combining)],
    // );

    // final listener = ListenerMock();

    // final removeListener = combining.subscribe(owner2, (read) => listener(read()));

    // verify(listener(2)).called(1);
    // verifyNoMoreInteractions(listener);

    // ref.state++;

    // verify(listener(4)).called(1);
    // verifyNoMoreInteractions(listener);

    // owner2.dispose();

    // ref.state++;
    // verifyNoMoreInteractions(listener);

    // owner.dispose();
  }, skip: true);
}

class ListenerMock extends Mock {
  void call(int value);
}
