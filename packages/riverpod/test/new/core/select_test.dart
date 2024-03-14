import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('provider.select', () {
    test('handles when the selector throws', () {
      final provider = Provider((ref) => Object());
      final container = ProviderContainer.test();

      final errors = <Object>[];
      container.read(provider);
      final sub = container.listen(
        provider.select((value) => throw StateError('Foo')),
        (_, __) {},
        onError: (err, stack) => errors.add(err),
      );

      container.invalidate(provider);

      expect(
        sub.read,
        throwsA(isStateError.having((e) => e.message, 'message', 'Foo')),
      );
      expect(errors, [isStateError.having((e) => e.message, 'message', 'Foo')]);
    });
  });
}
