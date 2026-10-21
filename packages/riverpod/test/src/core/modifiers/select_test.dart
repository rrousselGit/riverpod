import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ContainerReadElement;
import 'package:test/test.dart';

import '../../matrix.dart';
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
        (_, _) {},
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
        final provider = NotifierProvider<DeferredNotifier<String>, String>(
          () => DeferredNotifier((ref, self) => 'Hello'),
        );
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
        final provider = NotifierProvider<DeferredNotifier<String>, String>(
          () => DeferredNotifier((ref, self) => 'Hello'),
        );
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
          final provider = NotifierProvider<DeferredNotifier<String>, String>(
            () => DeferredNotifier((ref, self) => 'Hello'),
          );
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

    test('can chain select', () {
      final container = ProviderContainer.test();

      var buildCount = 0;
      final dep = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);
      final provider = Provider((ref) {
        buildCount++;
        return ref.watch(
          dep.select((value) => value % 10).select((value) => value < 5),
        );
      });

      expect(buildCount, 0);
      expect(container.read(provider), true);
      expect(buildCount, 1);

      container.read(dep.notifier).state = 3;

      expect(container.read(provider), true);
      expect(buildCount, 1);

      container.read(dep.notifier).state = 7;

      expect(container.read(provider), false);
      expect(buildCount, 2);

      container.read(dep.notifier).state = 8;

      expect(container.read(provider), false);
      expect(buildCount, 2);

      container.read(dep.notifier).state = 18;

      expect(container.read(provider), false);
      expect(buildCount, 2);
    });

    test('on provider that threw, exceptions bypass the selector', () {
      final container = ProviderContainer.test();
      final dep = Provider<int>((ref) {
        throw UnimplementedError();
      });
      final provider = Provider<int>((ref) {
        return ref.watch(dep.select((value) => throw StateError('message')));
      });

      expect(
        () => container.read(provider),
        throwsProviderException(isProviderException(isUnimplementedError)),
      );
    });

    test(
      'when rebuilding a provider after an uncaught selected exception, correctly updates dependents',
      () {
        final container = ProviderContainer.test();
        final throws = NotifierProvider<DeferredNotifier<bool>, bool>(
          () => DeferredNotifier((ref, self) => true),
        );
        final provider = Provider((ref) {
          if (ref.watch(throws)) {
            throw UnimplementedError();
          }
          return 0;
        });

        final dep = Provider((ref) {
          return ref.watch(provider.select((value) => value));
        });

        expect(
          () => container.read(dep),
          throwsProviderException(isProviderException(isUnimplementedError)),
        );

        container.read(throws.notifier).state = false;

        expect(container.read(dep), 0);
      },
    );

    test('can watch selectors', () {
      final container = ProviderContainer.test();
      final provider = NotifierProvider<CounterNotifier, int>(
        name: 'provider',
        CounterNotifier.new,
      );
      final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
      final isEvenListener = Listener<bool>();
      var buildCount = 0;

      final another = Provider<bool>(name: 'another', (ref) {
        buildCount++;
        return ref.watch(provider.select(isEvenSelector.call));
      });

      container.listen(another, isEvenListener.call, fireImmediately: true);

      expect(buildCount, 1);
      verifyOnly(isEvenListener, isEvenListener(null, true));
      verifyOnly(isEvenSelector, isEvenSelector(0));

      container.read(provider.notifier).state = 2;

      expect(container.read(another), true);
      expect(buildCount, 1);
      verifyOnly(isEvenSelector, isEvenSelector(2));
      verifyNoMoreInteractions(isEvenListener);

      container.read(provider.notifier).state = 3;

      expect(container.read(another), false);
      expect(buildCount, 2);
      verify(isEvenSelector(3)).called(2);
      verifyOnly(isEvenListener, isEvenListener(true, false));
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
