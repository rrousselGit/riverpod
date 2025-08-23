import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show NodeInternal;
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
        throwsProviderException(
          isStateError.having((e) => e.message, 'message', 'Foo'),
        ),
      );
      expect(errors, [isStateError.having((e) => e.message, 'message', 'Foo')]);
    });

    group('handles listen(weak: true)', () {
      test(
        'supports calling ProviderSubscription.read when no value were emitted yet',
        () {
          final container = ProviderContainer.test();
          final provider = Provider((ref) => 0);

          final sub = container.listen(
            provider.select((value) => 42),
            (previous, value) {},
          );

          expect(sub.read(), 42);
        },
      );

      test('closing the subscription updated element.hasListeners', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);

        final sub = container.listen(
          provider.select((value) => 0),
          weak: true,
          (previous, value) {},
        );

        expect(
          container.readProviderElement(provider).weakDependents,
          isNotEmpty,
        );

        sub.close();

        expect(container.readProviderElement(provider).weakDependents, isEmpty);
      });

      test(
        'calls mayNeedDispose in ProviderSubscription.read for the sake of listen(weak: true)',
        () async {
          final container = ProviderContainer.test();
          final onDispose = OnDisposeMock();
          final provider = Provider.autoDispose((ref) {
            ref.onDispose(onDispose.call);
            return 0;
          });

          final element = container.readProviderElement(provider);

          final sub = container.listen(
            provider.select((value) => value),
            weak: true,
            (previous, value) {},
          );

          expect(sub.read(), 0);
          verifyZeroInteractions(onDispose);

          await container.pump();

          verifyOnly(onDispose, onDispose());
        },
      );

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
        'instead of considering that "previous" is missing.',
        () {
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
        },
      );
    });
  });

  group('_ProviderSelector', () {
    test('handles pause/resume', () {
      final container = ProviderContainer.test();
      final provider = Provider((ref) => 0);

      final element = container.readProviderElement(provider);

      final sub = container.listen(
        provider.select((value) => null),
        (previous, next) {},
      );

      expect(element.isActive, true);

      sub.pause();

      expect(element.isActive, false);

      sub.resume();

      expect(element.isActive, true);
    });
  });
}
