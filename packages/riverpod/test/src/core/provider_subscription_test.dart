import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ContainerReadElement;
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  group('_ProxySubscription', () {
    test('handles pause/resume', () {
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) => 0);

      final element = container.readProviderElement(provider);

      final sub = container.listen(provider.future, (previous, next) {});

      expect(element.isActive, true);

      sub.pause();

      expect(element.isActive, false);

      sub.resume();

      expect(element.isActive, true);
    });

    test('closing a paused subscription unpauses the element', () {
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) => 0);

      final element = container.readProviderElement(provider);

      final sub = container.listen(provider.future, (previous, next) {});

      expect(element.isActive, true);

      sub.pause();

      expect(element.isActive, false);

      sub.close();
      container.listen(provider.future, (previous, next) {});

      expect(element.isActive, true);
    });

    group('read', () {
      test('throws if used after close', () {
        final container = ProviderContainer.test();
        final provider = FutureProvider((ref) async => 0);

        final sub = container.listen(provider.future, (prev, value) {});
        sub.close();

        expect(sub.read, throwsStateError);
      });
    });
  });

  group('ProviderSubscription.resume', () {
    test(
      'Resuming a paused subscription with no missed data event does not call listeners',
      () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);
        final listener = Listener<int>();

        final sub = container.listen(provider, listener.call);

        sub.pause();

        sub.resume();

        verifyZeroInteractions(listener);
      },
    );

    test(
      'Resuming a paused subscription with missed data emits the last event',
      () async {
        final container = ProviderContainer.test();
        final provider = NotifierProvider<DeferredNotifier<int>, int>(
          () => DeferredNotifier((ref, _) => 0),
        );
        final listener = Listener<int>();

        final notifier = container.read(provider.notifier);

        final sub = container.listen(provider, listener.call);

        sub.pause();

        notifier.state = 1;
        notifier.state = 2;

        sub.resume();

        verifyOnly(listener, listener(1, 2));

        sub.resume();

        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'Resuming a paused subscription with missed error emits the last error',
      () async {
        final container = ProviderContainer.test();
        late Error toThrow;
        final stack = StackTrace.current;
        final provider = Provider<int>((ref) {
          Error.throwWithStackTrace(toThrow, stack);
        });
        final listener = Listener<int>();
        final onError = ErrorListener();
        final err = Error();
        final err2 = Error();

        toThrow = err;

        final sub = container.listen(
          provider,
          listener.call,
          onError: onError.call,
        );

        sub.pause();

        toThrow = err2;
        try {
          container.refresh(provider);
        } catch (e) {
          // Will rethrow the error, but we don't care about it here
        }

        sub.resume();

        verifyOnly(onError, onError(err2, stack));

        sub.resume();

        verifyNoMoreInteractions(onError);
        verifyZeroInteractions(listener);
      },
    );

    test('needs to be called as many times as pause() was called', () {
      final container = ProviderContainer.test();
      final provider = Provider((ref) => 0);

      final sub = container.listen(provider, (p, b) {});

      sub.pause();
      sub.pause();
      sub.pause();

      sub.resume();
      expect(sub.isPaused, true);
      sub.resume();
      expect(sub.isPaused, true);
      sub.resume();
      expect(sub.isPaused, false);
    });
  });

  group('ProviderSubscription', () {
    late ProviderContainer container;
    final didChange = Listener<int>();

    setUp(() {
      container = ProviderContainer.test();
    });

    tearDown(() {
      reset(didChange);
      container.dispose();
    });

    test('no longer call listeners anymore after close', () {
      final first = NotifierProvider<Counter, int>(Counter.new);
      final provider = Provider((ref) => ref.watch(first));
      final element = container.readProviderElement(provider);

      expect(element.hasNonWeakListeners, false);

      final sub = container.listen(provider, didChange.call);

      expect(element.hasNonWeakListeners, true);

      sub.close();
      container.read(first.notifier).increment();

      expect(element.hasNonWeakListeners, false);
      verifyZeroInteractions(didChange);
    });

    group('.read', () {
      test('rethrows the exception thrown when building a provider', () {
        final error = Error();
        final provider = Provider<int>((ref) => throw error, name: 'hello');

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read, throwsProviderException(error));
      });

      test(
        'rethrows the exception thrown when building a selected provider',
        () {
          final error = Error();
          final provider = Provider<int>((ref) => throw error, name: 'hello');

          final sub = container.listen(
            provider.select((value) => value),
            (_, _) {},
          );

          expect(sub.read, throwsProviderException(error));
        },
      );

      test('flushes the provider', () {
        final first = NotifierProvider<Counter, int>(Counter.new);
        final provider = Provider((ref) => ref.watch(first));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), 0);

        container.read(first.notifier).increment();

        expect(sub.read(), 1);
      });

      test('flushes the selected provider', () {
        final first = NotifierProvider<Counter, int>(Counter.new);
        final provider = Provider((ref) => ref.watch(first));

        final sub = container.listen(
          provider.select((value) => value),
          (_, _) {},
        );

        expect(sub.read(), 0);

        container.read(first.notifier).increment();

        expect(sub.read(), 1);
      });
    });
  });
}
