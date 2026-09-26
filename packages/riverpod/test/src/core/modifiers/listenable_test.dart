import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderException;
import 'package:test/test.dart';

import '../../utils.dart';

class Counter extends Notifier<int> {
  @override
  int build() => 0;
}

class UserNotifier extends Notifier<({int age, String name})> {
  @override
  ({int age, String name}) build() => (age: 20, name: 'Alice');
}

void main() {
  final counterProvider = NotifierProvider<Counter, int>(Counter.new);
  final userProvider = NotifierProvider<UserNotifier, ({int age, String name})>(
    UserNotifier.new,
  );

  group('provider.listenable', () {
    test('returns a ValueListenable that yields current provider state', () {
      final container = ProviderContainer.test();

      final sub = container.listen(counterProvider.listenable, (_, _) {});
      final listenable = sub.read();
      expect(listenable.value, 0);

      container.read(counterProvider.notifier).state = 10;
      expect(listenable.value, 10);
    });

    test('notifies listeners when provider state updates', () {
      final container = ProviderContainer.test();

      final sub = container.listen(counterProvider.listenable, (_, _) {});
      final listenable = sub.read();
      var count = 0;
      listenable.addListener(() {
        count++;
      });

      expect(count, 0);

      container.read(counterProvider.notifier).state = 5;
      expect(count, 1);
      expect(listenable.value, 5);

      container.read(counterProvider.notifier).state = 10;
      expect(count, 2);
      expect(listenable.value, 10);
    });

    test('throws exception on .value read if provider fails', () {
      final container = ProviderContainer.test();
      final provider = Provider<int>((ref) {
        throw StateError('failed');
      });

      final sub = container.listen(provider.listenable, (_, _) {});
      final listenable = sub.read();
      expect(() => listenable.value, throwsA(isA<ProviderException>()));
    });

    test('handles select modifiers correctly', () {
      final container = ProviderContainer.test();

      final sub = container.listen(
        userProvider.select((v) => v.age).listenable,
        (_, _) {},
      );
      final listenable = sub.read();
      expect(listenable.value, 20);

      var count = 0;
      listenable.addListener(() {
        count++;
      });

      // Update unrelated property - should not notify
      container.read(userProvider.notifier).state = (age: 20, name: 'Bob');
      expect(count, 0);

      // Update age - should notify
      container.read(userProvider.notifier).state = (age: 21, name: 'Bob');
      expect(count, 1);
      expect(listenable.value, 21);
    });

    test('handles autoDispose cleanups', () async {
      final container = ProviderContainer.test();
      final onDispose = OnDisposeMock();
      final provider = Provider.autoDispose((ref) {
        ref.onDispose(onDispose.call);
        return 0;
      });

      final sub = container.listen(provider.listenable, (prev, next) {});
      verifyZeroInteractions(onDispose);

      sub.close();
      await container.pump();

      verifyOnly(onDispose, onDispose());
    });
    test(
      'addListener/removeListener handle pausing/resuming the associated provider',
      () async {
        final container = ProviderContainer.test();
        var cancelCount = 0;
        var resumeCount = 0;
        final provider = Provider.autoDispose((ref) {
          ref.onCancel(() => cancelCount++);
          ref.onResume(() => resumeCount++);
          return 0;
        });

        final sub = container.listen(provider.listenable, (prev, next) {});
        final listenable = sub.read();

        await Future.microtask(() {});

        expect(cancelCount, 1);
        expect(resumeCount, 0);

        void listener() {}
        listenable.addListener(listener);

        await Future.microtask(() {});

        expect(cancelCount, 1);
        expect(resumeCount, 1);

        listenable.removeListener(listener);

        await Future.microtask(() {});

        expect(cancelCount, 2);
        expect(resumeCount, 1);
      },
    );
  });

  group('container.read(provider.listenable)', () {
    test('throws a clear StateError instead of an internal one, since the '
        'returned object needs a live subscription that container.read has '
        'already closed by the time the caller can touch it', () {
      final container = ProviderContainer.test();

      final listenable = container.read(counterProvider.listenable);

      expect(
        () => listenable.value,
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'The subscription backing this `.listenable` was closed. '
                'Obtain `.listenable` through `ref.watch`, `ref.listen` or '
                '`container.listen`, not `read`.',
          ),
        ),
      );
    });

    test('still throws that StateError regardless of whether the provider was '
        'already mounted before the read', () {
      final container = ProviderContainer.test();
      // Mount the provider through an unrelated read first.
      expect(container.read(counterProvider), 0);

      final listenable = container.read(counterProvider.listenable);

      expect(() => listenable.value, throwsStateError);
    });

    test('addListener throws the same StateError, since ListenableBuilder '
        'and AnimatedBuilder call it without ever reading .value first', () {
      final container = ProviderContainer.test();

      final listenable = container.read(counterProvider.listenable);

      expect(
        () => listenable.addListener(() {}),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'The subscription backing this `.listenable` was closed. '
                'Obtain `.listenable` through `ref.watch`, `ref.listen` or '
                '`container.listen`, not `read`.',
          ),
        ),
      );
    });
  });

  group('provider.listenable on a derived provider (pause bypass)', () {
    test('reading .value forces a fresh value from a Provider deriving from a '
        'NotifierProvider, even though the listenable started paused because '
        'no listener was ever added to it', () {
      final container = ProviderContainer.test();
      final doubled = Provider<int>((ref) => ref.watch(counterProvider) * 2);

      final sub = container.listen(doubled.listenable, (_, _) {});
      final listenable = sub.read();
      expect(listenable.value, 0);

      container.read(counterProvider.notifier).state = 5;

      expect(listenable.value, 10);
    });

    test('same as above for a Provider.autoDispose deriving from a '
        'NotifierProvider', () {
      final container = ProviderContainer.test();
      final doubled = Provider.autoDispose<int>(
        (ref) => ref.watch(counterProvider) * 2,
      );

      final sub = container.listen(doubled.listenable, (_, _) {});
      final listenable = sub.read();
      expect(listenable.value, 0);

      container.read(counterProvider.notifier).state = 5;

      expect(listenable.value, 10);
    });
  });
}
