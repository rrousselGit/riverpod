// ignore_for_file: prefer_const_constructors
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/builder.dart';
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
      FutureProvider((ref) async => 42, name: 'foo'),
      isA<FutureProvider<int>>().having((s) => s.name, 'name', 'foo'),
    );
  });

  test('StreamProvider', () {
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
      isA<StateNotifierProvider<StateController<int>, int>>()
          .having((s) => s.name, 'name', 'foo'),
    );
  });

  test('Provider', () {
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
      Provider((ref) => StateController(42), name: 'foo'),
      isA<Provider<StateController<int>>>()
          .having((s) => s.name, 'name', 'foo'),
    );
  });

  test('StateProvider', () {
    StateProviderFamilyBuilder();

    expect(
      StateProvider.family,
      const StateProviderFamilyBuilder(),
    );
    expect(
      StateProvider((ref) => StateController(42), name: 'foo'),
      isA<StateProvider<StateController<int>>>()
          .having((s) => s.name, 'name', 'foo'),
    );
  });
}
