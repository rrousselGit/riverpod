import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  test('StateProvideyFamily', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final owner = ProviderContainer();

    expect(
      provider(0).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', '0'),
    );
    expect(
      provider(1).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', '1'),
    );
  });

  test('StateProvideyFamily override', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final owner = ProviderContainer(overrides: [
      provider.overrideAs((ref, a) => 'override $a'),
    ]);

    expect(
      provider(0).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', 'override 0'),
    );
    expect(
      provider(1).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', 'override 1'),
    );
  });
  test('can specify name', () {
    final provider = SetStateProvider(
      (_) => 0,
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = SetStateProvider((_) => 0);

    expect(provider2.name, isNull);
  });
  test('is AlwaysAliveProviderBase', () {
    final provider = SetStateProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProviderBase>());
  });
  test('SetStateProviderReference can read and write state', () {
    final owner = ProviderContainer();
    SetStateProviderReference<int> ref;
    int initialValue;
    final provider = SetStateProvider<int>((r) {
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
    final owner = ProviderContainer();
    SetStateProviderReference<int> ref;
    final provider = SetStateProvider<int>((r) {
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

class ListenerMock extends Mock {
  void call(int value);
}
