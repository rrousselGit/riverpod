import 'package:riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/builder.dart';
import 'package:test/test.dart';

void main() {
  test('builders', () {
    expect(
      StateNotifierProvider.autoDispose.family,
      StateNotifierProvider.family.autoDispose,
    );
  });

  test('StateNotifierProvider', () {
    // Tear-offs call the constructors at runtime, which const invocations
    // would not, for the sake of coverage.
    for (final constructor in <Object Function()>[
      StateNotifierProviderFamilyBuilder.new,
      AutoDisposeStateNotifierProviderBuilder.new,
      AutoDisposeStateNotifierProviderFamilyBuilder.new,
    ]) {
      constructor();
    }

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

  test('StateProvider', () {
    // See the StateNotifierProvider test.
    for (final constructor in <Object Function()>[
      StateProviderFamilyBuilder.new,
    ]) {
      constructor();
    }

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
