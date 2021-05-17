// ignore_for_file: prefer_const_constructors
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/builders.dart';
import 'package:test/test.dart';

void main() {
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
    final futureProviderBuilder = FutureProviderBuilder();
    FutureProviderFamilyBuilder();
    AutoDisposeFutureProviderBuilder();
    AutoDisposeFutureProviderFamilyBuilder();

    expect(
      FutureProvider.family,
      const FutureProviderFamilyBuilder(),
    );
    expect(
      FutureProvider.autoDispose,
      const AutoDisposeFutureProviderBuilder(),
    );
    expect(
      FutureProvider.autoDispose.family,
      FutureProvider.family.autoDispose,
    );
    expect(
      futureProviderBuilder.autoDispose,
      FutureProvider.autoDispose,
    );
    expect(
      futureProviderBuilder.family,
      FutureProvider.family,
    );
    expect(
      futureProviderBuilder((ref) async => 42, name: 'foo'),
      isA<FutureProvider<int>>().having((s) => s.name, 'name', 'foo'),
    );
  });

  test('StreamProvider', () {
    final streamProviderBuilder = StreamProviderBuilder();
    StreamProviderFamilyBuilder();
    AutoDisposeStreamProviderBuilder();
    AutoDisposeStreamProviderFamilyBuilder();

    expect(
      StreamProvider.family,
      const StreamProviderFamilyBuilder(),
    );
    expect(
      StreamProvider.autoDispose,
      const AutoDisposeStreamProviderBuilder(),
    );
    expect(
      StreamProvider.autoDispose.family,
      StreamProvider.family.autoDispose,
    );
    expect(
      streamProviderBuilder.autoDispose,
      StreamProvider.autoDispose,
    );
    expect(
      streamProviderBuilder.family,
      StreamProvider.family,
    );
    expect(
      streamProviderBuilder((ref) => Stream.value(42), name: 'foo'),
      isA<StreamProvider<int>>().having((s) => s.name, 'name', 'foo'),
    );
  });

  test('StateNotifierProvider', () {
    final stateNotifierProviderBuilder = StateNotifierProviderBuilder();
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
      stateNotifierProviderBuilder.autoDispose,
      StateNotifierProvider.autoDispose,
    );
    expect(
      stateNotifierProviderBuilder.family,
      StateNotifierProvider.family,
    );
    expect(
      stateNotifierProviderBuilder<StateController<int>, int>(
        (ref) => StateController(42),
        name: 'foo',
      ),
      isA<StateNotifierProvider<StateController<int>, int>>()
          .having((s) => s.name, 'name', 'foo'),
    );
  });

  test('Provider', () {
    final providerBuilder = ProviderBuilder();
    ProviderFamilyBuilder();
    AutoDisposeProviderBuilder();
    AutoDisposeProviderFamilyBuilder();

    expect(
      Provider.family,
      const ProviderFamilyBuilder(),
    );
    expect(
      Provider.autoDispose,
      const AutoDisposeProviderBuilder(),
    );
    expect(
      Provider.autoDispose.family,
      Provider.family.autoDispose,
    );
    expect(
      providerBuilder.autoDispose,
      Provider.autoDispose,
    );
    expect(
      providerBuilder.family,
      Provider.family,
    );
    expect(
      providerBuilder((ref) => StateController(42), name: 'foo'),
      isA<Provider<StateController<int>>>()
          .having((s) => s.name, 'name', 'foo'),
    );
  });

  test('StateProvider', () {
    final stateProviderBuilder = StateProviderBuilder();
    StateProviderFamilyBuilder();

    expect(
      StateProvider.family,
      const StateProviderFamilyBuilder(),
    );
    expect(
      stateProviderBuilder.family,
      StateProvider.family,
    );
    expect(
      stateProviderBuilder((ref) => StateController(42), name: 'foo'),
      isA<StateProvider<StateController<int>>>()
          .having((s) => s.name, 'name', 'foo'),
    );
  });
}
