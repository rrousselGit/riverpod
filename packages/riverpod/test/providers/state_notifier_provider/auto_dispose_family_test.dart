import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StateNotifier.family', () {
    group('scoping an override overrides all the associated subproviders', () {
      test(
        'when passing the provider itself',
        () {},
        skip: true,
      );

      test(
        'when using provider.overrideWithValue',
        () {},
        skip: true,
      );

      test(
        'when using provider.overrideWithProvider',
        () {},
        skip: true,
      );
    });

    test('properly overrides ==', () {
      final family = StateNotifierProvider.autoDispose
          .family<Counter, int, int>((ref, _) => Counter());

      expect(family(0), family(0));
      expect(family(1), isNot(family(0)));
      expect(family(1), family(1));
    });
  });
}
