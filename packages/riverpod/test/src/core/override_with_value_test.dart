import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('AsyncValueProvider', () {
    test(
      'when overridden with an error but provider.future is not listened to, '
      'it should not emit an error to the zone',
      () async {
        final error = Error();
        final future = FutureProvider<int>((ref) async => 0);

        final container = ProviderContainer.test(
          overrides: [
            future.overrideWithValue(AsyncValue.error(error, StackTrace.empty)),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(future),
          AsyncValue<int>.error(error, StackTrace.empty),
        );

        // the test will naturally fail if a non-caught future is created
      },
    );

    group('mock as value', () {
      test('value immediately then other value', () async {
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.data(42))],
        );

        await expectLater(container.read(provider.future), completion(42));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), const AsyncValue.data(42));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(21)),
        ]);

        await expectLater(container.read(provider.future), completion(21));
        expect(sub.read(), const AsyncValue.data(21));
      });

      test('value immediately then error', () async {
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.data(42))],
        );

        await expectLater(container.read(provider.future), completion(42));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), const AsyncValue.data(42));

        container.updateOverrides([
          provider.overrideWithValue(
            const AsyncValue.error(21, StackTrace.empty),
          ),
        ]);

        await expectLater(container.read(provider.future), throwsA(21));
        expect(
          sub.read(),
          const AsyncValue<int>.error(
            21,
            StackTrace.empty,
          ).copyWithPrevious(const AsyncData(42)),
        );
      });

      test('value immediately then loading', () async {
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.data(42))],
        );

        final future = container.read(provider.future);

        await expectLater(future, completion(42));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), const AsyncValue<int>.data(42));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        expect(container.read(provider.future), isNot(future));
        expect(
          sub.read(),
          const AsyncLoading<int>().copyWithPrevious(
            const AsyncValue<int>.data(42),
          ),
        );
      });

      test('loading immediately then value', () async {
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.loading())],
        );

        final future = container.read(provider.future);

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), const AsyncValue<int>.loading());

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        expect(sub.read(), const AsyncValue<int>.data(42));

        await expectLater(future, completion(42));
      });

      test('loading immediately then error', () async {
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.loading())],
        );

        final future = container.read(provider.future);

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), const AsyncValue<int>.loading());

        final stackTrace = StackTrace.current;

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
        ]);

        expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

        await expectLater(future, throwsA(42));
      });

      test('loading immediately then loading', () async {
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.loading())],
        );
        final listener = Listener<AsyncValue<int>>();

        final future = container.read(provider.future);

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        verifyNoMoreInteractions(listener);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        verifyOnly(
          listener,
          listener(const AsyncValue.loading(), const AsyncValue.data(42)),
        );
        await expectLater(future, completion(42));
      });

      test('error immediately then different error', () async {
        final stackTrace = StackTrace.current;
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
          ],
        );

        await expectLater(container.read(provider.future), throwsA(42));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(21, stackTrace)),
        ]);

        await expectLater(container.read(provider.future), throwsA(21));
        expect(sub.read(), AsyncValue<int>.error(21, stackTrace));
      });

      test('error immediately then different stacktrace', () async {
        final stackTrace = StackTrace.current;
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
          ],
        );

        final future = container.read(provider.future);

        await expectLater(future, throwsA(42));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

        final stack2 = StackTrace.current;

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(42, stack2)),
        ]);

        expect(container.read(provider.future), isNot(future));
        await expectLater(container.read(provider.future), throwsA(42));
        expect(sub.read(), AsyncValue<int>.error(42, stack2));
      });

      test('error immediately then data', () async {
        final stackTrace = StackTrace.current;
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
          ],
        );

        await expectLater(container.read(provider.future), throwsA(42));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        await expectLater(container.read(provider.future), completion(42));
        expect(
          sub.read(),
          const AsyncValue<int>.data(
            42,
          ).copyWithPrevious(AsyncError(42, stackTrace)),
        );
      });

      test('error immediately then loading', () async {
        final stackTrace = StackTrace.current;
        final provider = FutureProvider((_) async => 0);
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
          ],
        );

        final future = container.read(provider.future);
        await expectLater(future, throwsA(42));

        final sub = container.listen(provider, (_, _) {});

        expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        expect(container.read(provider.future), isNot(future));
        expect(
          sub.read(),
          const AsyncLoading<int>().copyWithPrevious(
            AsyncError<int>(42, stackTrace),
          ),
        );
      });
    });

    group('.future', () {
      final provider = StreamProvider<int>((ref) async* {});

      test('supports loading then error then loading', () async {
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncLoading())],
        );

        var future = container.read(provider.future);

        final error = Error();

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(error, StackTrace.empty)),
        ]);

        container.listen(provider, (p, n) {});
        expect(container.read(provider.future), future);

        await expectLater(future, throwsA(error));
        expect(await future.stackTrace, StackTrace.empty);

        final error2 = Error();

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        future = container.read(provider.future);

        container.updateOverrides([
          provider.overrideWithValue(
            AsyncValue.error(error2, StackTrace.empty),
          ),
        ]);

        expect(container.read(provider.future), future);

        await expectLater(future, throwsA(error2));
        expect(await future.stackTrace, StackTrace.empty);
      });

      test('supports loading then error then another error', () async {
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncLoading())],
        );

        container.listen(provider, (p, n) {});
        var future = container.read(provider.future);

        final error = Error();

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(error, StackTrace.empty)),
        ]);

        expect(container.read(provider.future), future);

        await expectLater(future, throwsA(error));
        expect(await future.stackTrace, StackTrace.empty);

        final error2 = Error();

        // error without passing by an intermediary loading state
        container.updateOverrides([
          provider.overrideWithValue(
            AsyncValue.error(error2, StackTrace.empty),
          ),
        ]);

        future = container.read(provider.future);

        await expectLater(future, throwsA(error2));
        expect(await future.stackTrace, StackTrace.empty);
      });

      test('supports loading then data then loading', () async {
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncLoading())],
        );

        container.listen(provider, (p, n) {});
        var future = container.read(provider.future);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        expect(container.read(provider.future), future);
        await expectLater(future, completion(42));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        future = container.read(provider.future);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(21)),
        ]);

        expect(container.read(provider.future), future);
        await expectLater(future, completion(21));
      });

      test('supports loading then data then another data', () async {
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncLoading())],
        );

        container.listen(provider, (p, n) {});
        var future = container.read(provider.future);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        expect(container.read(provider.future), future);
        await expectLater(future, completion(42));

        // data without passing by an intermediary loading state
        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(21)),
        ]);

        future = container.read(provider.future);

        await expectLater(future, completion(21));
      });
    });

    group('overrideWithValue(T)', () {
      test(
        'when overridden with an error but provider.stream is not listened to, it should not emit an error to the zone',
        () async {
          final error = Error();
          final stream = StreamProvider<int>((ref) => const Stream.empty());

          final container = ProviderContainer.test(
            overrides: [
              stream.overrideWithValue(
                AsyncValue.error(error, StackTrace.empty),
              ),
            ],
          );
          addTearDown(container.dispose);

          expect(
            container.read(stream),
            AsyncValue<int>.error(error, StackTrace.empty),
          );
        },
      );
    });

    group('from StreamProvider.overrideWithValue', () {
      test('read currentValue before first value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.loading())],
        );

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        await expectLater(future, completion(42));
      });

      test('read currentValue before after value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.loading())],
        );

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, completion(42));
      });

      test('read currentValue before first error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.loading())],
        );

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        container.updateOverrides([
          provider.overrideWithValue(
            const AsyncValue.error(42, StackTrace.empty),
          ),
        ]);

        await expectLater(future, throwsA(42));
      });

      test('read currentValue before after error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.loading())],
        );

        container.updateOverrides([
          provider.overrideWithValue(
            const AsyncValue.error(42, StackTrace.empty),
          ),
        ]);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, throwsA(42));
      });

      test('synchronous first event', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.data(42))],
        );

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, completion(42));
      });
    });
  });
}

extension on Future<Object?> {
  Future<StackTrace?> get stackTrace async {
    try {
      await this;
      return null;
    } catch (e, s) {
      return s;
    }
  }
}
