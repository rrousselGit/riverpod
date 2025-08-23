// ignore_for_file: prefer_const_constructors
import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/builder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('_ProxySubscription', () {
    group('read', () {
      test('throws if used after close', () {
        final container = ProviderContainer.test();
        final provider = FutureProvider((ref) async => 0);

        final sub = container.listen(provider.future, (prev, value) {});
        sub.close();

        expect(sub.read, throwsStateError);
      });
    });
  });

  test('Listening to a modifier correctly fires ref life-cycles', () async {
    final container = ProviderContainer.test();
    final onDispose = OnDisposeMock();
    final onAddListener = OnAddListener();
    final onRemoveListener = OnRemoveListener();
    final onResume = OnResume();
    final onCancel = OnCancel();

    final provider = FutureProvider((ref) {
      ref.onDispose(onDispose.call);
      ref.onAddListener(onAddListener.call);
      ref.onRemoveListener(onRemoveListener.call);
      ref.onCancel(onCancel.call);
      ref.onResume(onResume.call);
      return 0;
    });

    final sub = container.listen(provider.future, (prev, value) {});

    verifyOnly(onAddListener, onAddListener());

    final sub2 = container.listen(provider.future, (prev, value) {});

    verifyOnly(onAddListener, onAddListener());

    sub.close();

    verifyOnly(onRemoveListener, onRemoveListener());
    verifyZeroInteractions(onCancel);

    sub2.close();

    verifyOnly(onRemoveListener, onRemoveListener());
    verifyZeroInteractions(onResume);
    verifyOnly(onCancel, onCancel());

    container.listen(provider.future, (prev, value) {});

    verifyOnly(onAddListener, onAddListener());
    verifyOnly(onResume, onResume());

    container.listen(provider.future, (prev, value) {});

    verifyOnly(onAddListener, onAddListener());
    verifyNoMoreInteractions(onCancel);
    verifyNoMoreInteractions(onResume);
    verifyZeroInteractions(onDispose);

    container.invalidate(provider);

    verifyOnly(onDispose, onDispose());
  });

  test('builders', () {
    expect(Provider.autoDispose.family, Provider.family.autoDispose);
    expect(
      StateNotifierProvider.autoDispose.family,
      StateNotifierProvider.family.autoDispose,
    );
    expect(
      StreamProvider.autoDispose.family,
      StreamProvider.family.autoDispose,
    );
  });

  test('FutureProvider', () {
    FutureProviderFamilyBuilder();
    AutoDisposeFutureProviderBuilder();
    AutoDisposeFutureProviderFamilyBuilder();

    expect(FutureProvider.family, const FutureProviderFamilyBuilder());
    expect(
      FutureProvider.autoDispose,
      const AutoDisposeFutureProviderBuilder(),
    );
    expect(
      FutureProvider.autoDispose.family,
      FutureProvider.family.autoDispose,
    );
    expect(
      FutureProvider((ref) async => 42, name: 'foo'),
      isA<FutureProvider<int>>().having((s) => s.name, 'name', 'foo'),
    );
  });

  test('StreamProvider', () {
    StreamProviderFamilyBuilder();
    AutoDisposeStreamProviderBuilder();
    AutoDisposeStreamProviderFamilyBuilder();

    expect(StreamProvider.family, const StreamProviderFamilyBuilder());
    expect(
      StreamProvider.autoDispose,
      const AutoDisposeStreamProviderBuilder(),
    );
    expect(
      StreamProvider.autoDispose.family,
      StreamProvider.family.autoDispose,
    );
    expect(
      StreamProvider((ref) => Stream.value(42), name: 'foo'),
      isA<StreamProvider<int>>().having((s) => s.name, 'name', 'foo'),
    );
  });

  test('StateNotifierProvider', () {
    StateNotifierProviderFamilyBuilder();
    AutoDisposeStateNotifierProviderBuilder();
    AutoDisposeStateNotifierProviderFamilyBuilder();

    expect(
      StateNotifierProvider.family,
      const StateNotifierProviderFamilyBuilder(),
    );
    expect(
      StateNotifierProvider.autoDispose,
      const AutoDisposeStateNotifierProviderBuilder(),
    );
    expect(
      StateNotifierProvider.autoDispose.family,
      StateNotifierProvider.family.autoDispose,
    );
    expect(
      StateNotifierProvider<StateController<int>, int>(
        (ref) => StateController(42),
        name: 'foo',
      ),
      isA<StateNotifierProvider<StateController<int>, int>>().having(
        (s) => s.name,
        'name',
        'foo',
      ),
    );
  });

  test('Provider', () {
    ProviderFamilyBuilder();
    AutoDisposeProviderBuilder();
    AutoDisposeProviderFamilyBuilder();

    expect(Provider.family, const ProviderFamilyBuilder());
    expect(Provider.autoDispose, const AutoDisposeProviderBuilder());
    expect(Provider.autoDispose.family, Provider.family.autoDispose);
    expect(
      Provider((ref) => StateController(42), name: 'foo'),
      isA<Provider<StateController<int>>>().having(
        (s) => s.name,
        'name',
        'foo',
      ),
    );
  });

  test('StateProvider', () {
    StateProviderFamilyBuilder();

    expect(StateProvider.family, const StateProviderFamilyBuilder());
    expect(
      StateProvider((ref) => StateController(42), name: 'foo'),
      isA<StateProvider<StateController<int>>>().having(
        (s) => s.name,
        'name',
        'foo',
      ),
    );
  });
}
