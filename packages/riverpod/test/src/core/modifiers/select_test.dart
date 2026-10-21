import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ContainerReadElement;
import 'package:test/test.dart';

import '../../utils.dart';

class _StringNotifier extends Notifier<String> {
  @override
  String build() => 'Hello';
}

void main() {
  final stringProvider = NotifierProvider<_StringNotifier, String>(
    _StringNotifier.new,
  );

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

      test(
        'supports calling ProviderSubscription.read when the provider was '
        'already mounted by a strong listener before the weak listener was added',
        () {
          final container = ProviderContainer.test();

          // A strong listener mounts the provider first, which is the whole
          // point of a weak listener: something else keeps it alive.
          container.listen(stringProvider, (previous, next) {});

          final sub = container.listen(
            stringProvider.select((value) => value[0]),
            (previous, next) {},
            weak: true,
          );

          expect(sub.read(), 'H');
        },
      );

      test('supports two weak listeners on an already-mounted provider', () {
        final container = ProviderContainer.test();

        container.listen(stringProvider, (previous, next) {});

        final subA = container.listen(
          stringProvider.select((value) => value[0]),
          (previous, next) {},
          weak: true,
        );
        final subB = container.listen(
          stringProvider.select((value) => value.toUpperCase()),
          (previous, next) {},
          weak: true,
        );

        expect(subA.read(), 'H');
        expect(subB.read(), 'HELLO');
      });

      test('supports reading the same weak subscription twice', () {
        final container = ProviderContainer.test();

        container.listen(stringProvider, (previous, next) {});

        final sub = container.listen(
          stringProvider.select((value) => value[0]),
          (previous, next) {},
          weak: true,
        );

        expect(sub.read(), 'H');
        expect(sub.read(), 'H');
      });

      test(
        'does not return a stale cached value once the selected value changes',
        () {
          final container = ProviderContainer.test();

          container.listen(stringProvider, (previous, next) {});

          final sub = container.listen(
            stringProvider.select((value) => value[0]),
            (previous, next) {},
            weak: true,
          );

          expect(sub.read(), 'H');

          container.read(stringProvider.notifier).state = 'World';

          expect(sub.read(), 'W');
        },
      );
    });

    test('can chain select', () {
      final container = ProviderContainer.test();

      var buildCount = 0;
      final dep = StateProvider((ref) => 0);
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
        final throws = StateProvider((ref) => true);
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
      final provider = StateNotifierProvider<StateController<int>, int>(
        name: 'provider',
        (ref) => StateController(0),
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
