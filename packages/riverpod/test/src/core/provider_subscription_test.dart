import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show NodeInternal;
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
    });

    test('Resuming a paused subscription with missed data emits the last event',
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
    });

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
    });

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
}
