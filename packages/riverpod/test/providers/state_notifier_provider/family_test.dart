import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StateNotifier.family', () {
    test(
      'StateNotifierProviderFamily.toString includes argument & name',
      () {},
      skip: true,
    );

    test('properly overrides ==', () {
      final family = StateNotifierProvider.family<Counter, int, int>(
          (ref, _) => Counter());

      expect(family(0), family(0));
      expect(family(1), isNot(family(0)));
      expect(family(1), family(1));
    });
  });
}
