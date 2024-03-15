import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

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

    group('handles listen(weak: true)', () {
      test('common use-case ', () {
        final provider = StateProvider((ref) => 'Hello');
        final container = ProviderContainer.test();
        final listener = Listener<String>();

        container.listen(
          provider.select((value) => value[0]),
          listener.call,
          weak: true,
        );

        verifyZeroInteractions(listener);

        container.read(provider);

        verifyOnly(listener, listener.call(null, 'H'));

        container.read(provider.notifier).state = 'World';

        verifyOnly(listener, listener.call('H', 'W'));

        container.read(provider.notifier).state = 'Will not notify';

        verifyNoMoreInteractions(listener);
      });

      test('calling `sub.read` on a weak listener will select the value', () {
        final provider = StateProvider((ref) => 'Hello');
        final container = ProviderContainer.test();
        final listener = Listener<String>();

        final sub = container.listen(
          provider.select((value) => value[0]),
          listener.call,
          weak: true,
        );

        verifyZeroInteractions(listener);

        expect(sub.read(), 'H');

        verifyOnly(listener, listener.call(null, 'H'));
      });

      test(
          'after calling `sub.read`, notifications correctly compare the previous and new value '
          'instead of considering that "previous" is missing.', () {
        final provider = StateProvider((ref) => 'Hello');
        final container = ProviderContainer.test();
        final listener = Listener<String>();

        final sub = container.listen(
          provider.select((value) => value[0]),
          listener.call,
          weak: true,
        );

        sub.read();

        verifyOnly(listener, listener.call(null, 'H'));

        container.read(provider.notifier).state = 'Hi';

        verifyNoMoreInteractions(listener);
      });
    });
  });
}
