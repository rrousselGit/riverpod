import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  test(
      'AutoDisposeSetStateProviderReference can be assigned to SetStateProviderReference',
      () {
    SetStateProviderReference ref;
    final provider = AutoDisposeSetStateProvider<int>((r) {
      ref = r;
      return 0;
    });
    final owner = ProviderStateOwner();

    provider.watchOwner(owner, (value) {});

    expect(ref, isNotNull);
  });
  test('destroys state when unsubsribing', () async {
    var initialValue = 42;
    final onDispose = OnDisposeMock();
    final provider = AutoDisposeSetStateProvider<int>((ref) {
      ref.onDispose(onDispose);
      return initialValue;
    });
    final owner = ProviderStateOwner();
    final listener = ListenerMock();

    final removeListener = provider.watchOwner(owner, listener);

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);

    removeListener();

    verifyNoMoreInteractions(onDispose);
    await Future<void>.value();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    initialValue = 21;

    provider.watchOwner(owner, listener);

    verify(listener(21)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
  });

  test('can specify name', () {
    final provider = AutoDisposeSetStateProvider(
      (_) => 0,
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = AutoDisposeSetStateProvider((_) => 0);

    expect(provider2.name, isNull);
  });
  test('is AutoDisposeProviderBase', () {
    final provider = AutoDisposeSetStateProvider((_) async => 42);

    expect(provider, isA<AutoDisposeProviderBase>());
  });
  test('AutoDisposeSetStateProviderReference can read and write state', () {
    final owner = ProviderStateOwner();
    SetStateProviderReference<int> ref;
    int initialValue;
    final provider = AutoDisposeSetStateProvider<int>((r) {
      initialValue = r.state;
      ref = r;
      return 0;
    });
    final listener = ListenerMock();

    final sub = provider.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(initialValue, null);
    expect(ref.state, 0);

    ref.state++;

    expect(ref.state, 1);

    verifyNoMoreInteractions(listener);
    sub.flush();

    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
  test('subscribe', () {
    final owner = ProviderStateOwner();
    SetStateProviderReference<int> ref;
    final provider = AutoDisposeSetStateProvider<int>((r) {
      ref = r;
      return 0;
    });
    final listener = ListenerMock();

    final sub = provider.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    sub.close();

    ref.state++;

    verifyNoMoreInteractions(listener);

    sub.flush();

    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
}

class OnDisposeMock extends Mock {
  void call();
}

class ListenerMock extends Mock {
  void call(int value);
}
