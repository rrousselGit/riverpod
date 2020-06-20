import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('SynchronousFuture', () {
    final futureProvider = FutureProvider((_) => SynchronousFuture(42));
    final owner = ProviderStateOwner();
    final listener = Listener();

    final sub = futureProvider.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );
    verify(listener(const AsyncValue.data(42)));
    verifyNoMoreInteractions(listener);

    sub.flush();

    verifyNoMoreInteractions(listener);
  });

  testWidgets('updates dependents with value', (tester) async {
    final futureProvider = FutureProvider((s) async => 42);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          child: Consumer((c, read) {
            return read(futureProvider).when(
              data: (data) => Text(data.toString()),
              loading: () => const Text('loading'),
              error: (dynamic err, stack) => Text('$err'),
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('42'), findsOneWidget);
  });
  testWidgets('updates dependents with error', (tester) async {
    final error = Error();
    final futureProvider = FutureProvider<int>((s) async => throw error);

    dynamic whenError;
    StackTrace whenStack;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          child: Consumer((c, read) {
            return read(futureProvider).when(
              data: (data) => Text(data.toString()),
              loading: () => const Text('loading'),
              error: (dynamic err, stack) {
                whenError = err;
                whenStack = stack;
                return const Text('error');
              },
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('error'), findsOneWidget);
    expect(whenError, error);
    expect(whenStack, isNotNull);
  });
  testWidgets("future completes after unmount does't crash", (tester) async {
    final completer = Completer<int>();
    final futureProvider = FutureProvider((s) => completer.future);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, read) {
          read(futureProvider);
          return Container();
        }),
      ),
    );

    // unmount ProviderScope which disposes the provider
    await tester.pumpWidget(Container());

    completer.complete();

    // wait for then to tick
    await Future.value(null);
  });
  testWidgets("future fails after unmount does't crash", (tester) async {
    final completer = Completer<int>();
    final futureProvider = FutureProvider((s) => completer.future);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, read) {
          read(futureProvider);
          return Container();
        }),
      ),
    );

    // unmount ProviderScope which disposes the provider
    await tester.pumpWidget(Container());

    final error = Error();
    completer.completeError(error);

    // wait for onError to tick
    await Future.value(null);
  });
  testWidgets('FutureProvider can be overriden with Future', (tester) async {
    var callCount = 0;
    final futureProvider = FutureProvider((s) async {
      callCount++;
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          futureProvider.overrideAs(FutureProvider((_) async => 21)),
        ],
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer((c, read) {
            return read(futureProvider).maybeWhen(
              data: (data) => Text(data.toString()),
              orElse: () => const Text('else'),
            );
          }),
        ),
      ),
    );

    expect(callCount, 0);
    expect(find.text('else'), findsOneWidget);

    await tester.pump();

    expect(find.text('21'), findsOneWidget);
  });
  group('debugOverrideWithValue', () {
    var callCount = 0;
    final futureProvider = FutureProvider((s) async {
      callCount++;
      return 42;
    });

    Future<int> future;
    var completed = false;
    final proxy = Provider<String>(
      (ref) {
        final first = ref.read(futureProvider);
        future = first.future
          ..then(
            (value) => completed = true,
            onError: (dynamic _) => completed = true,
          );
        return '';
      },
    );

    setUp(() {
      callCount = 0;
      completed = false;
      future = null;
    });

    final child = Directionality(
      textDirection: TextDirection.ltr,
      child: Consumer((c, read) {
        read(proxy);
        return read(futureProvider).when(
          data: (data) => Text(data.toString()),
          loading: () => const Text('loading'),
          error: (dynamic err, stack) {
            return const Text('error');
          },
        );
      }),
    );

    testWidgets('no-op if completed and rebuild with same value',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.data(42)),
          ],
          child: child,
        ),
      );

      expect(completed, true);
      await expectLater(future, completion(42));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.data(42)),
          ],
          child: child,
        ),
      );
    });
    testWidgets(
        'fails if completed with value and rebuild with different content',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.data(42)),
          ],
          child: child,
        ),
      );

      expect(completed, true);
      await expectLater(future, completion(42));

      final errors = <Object>[];

      await runZonedGuarded(
        () => tester.pumpWidget(
          ProviderScope(
            overrides: [
              futureProvider.debugOverrideWithValue(const AsyncValue.data(21)),
            ],
            child: child,
          ),
        ),
        (err, _) => errors.add(err),
      );

      expect(errors, [isUnsupportedError]);
    });
    testWidgets(
        'fails if completed with error and rebuild with different content',
        (tester) async {
      final error = Error();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(AsyncValue.error(error)),
          ],
          child: child,
        ),
      );

      expect(completed, true);
      await expectLater(future, throwsA(error));

      final errors = <Object>[];
      await runZonedGuarded(
        () => tester.pumpWidget(
          ProviderScope(
            overrides: [
              futureProvider.debugOverrideWithValue(const AsyncValue.data(21)),
            ],
            child: child,
          ),
        ),
        (err, _) => errors.add(err),
      );

      expect(errors, [isUnsupportedError]);
    });
    testWidgets(
        'FutureProviderDependency.future completes on rebuild with data',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.loading()),
          ],
          child: child,
        ),
      );

      // make sure the future doesn't just complete in one frame
      await Future.value(null);

      expect(completed, false);
      expect(future, isNotNull);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.data(42)),
          ],
          child: child,
        ),
      );

      expect(completed, true);
      await expectLater(future, completion(42));
    });
    testWidgets(
        'FutureProviderDependency.future completes on rebuild with error',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.loading()),
          ],
          child: child,
        ),
      );

      // make sure the future doesn't just complete in one frame
      await Future.value(null);

      expect(completed, false);
      expect(future, isNotNull);

      final error = Error();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(AsyncValue.error(error)),
          ],
          child: child,
        ),
      );

      expect(completed, true);
      await expectLater(future, throwsA(error));
    });

    testWidgets('FutureProviderDependency.future loading to loading is no-op',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.loading()),
          ],
          child: child,
        ),
      );

      expect(completed, false);
      expect(future, isNotNull);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.loading()),
          ],
          child: child,
        ),
      );

      // make sure the future doesn't just complete in one frame
      await Future.value(null);

      expect(completed, false);
      expect(future, isNotNull);
    });

    testWidgets('Initial build as loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.loading()),
          ],
          child: child,
        ),
      );

      expect(callCount, 0);
      expect(find.text('loading'), findsOneWidget);

      expect(completed, false);
      expect(future, isNotNull);
    });
    testWidgets('Initial build as value', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(const AsyncValue.data(42)),
          ],
          child: child,
        ),
      );

      expect(callCount, 0);
      expect(find.text('42'), findsOneWidget);

      expect(completed, true);
      await expectLater(future, completion(42));
    });
    testWidgets('Initial build as error', (tester) async {
      final error = Error();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            futureProvider.debugOverrideWithValue(AsyncValue.error(error)),
          ],
          child: child,
        ),
      );

      expect(callCount, 0);
      expect(find.text('error'), findsOneWidget);

      expect(completed, true);
      await expectLater(future, throwsA(error));
    });
  });
  testWidgets('FutureProvider into FutureProviderFamily', (tester) async {
    final futureProvider = FutureProvider((_) async => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      final other = ref.read(futureProvider);
      return await other.future * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer((c, read) {
            return read(futureProviderFamily).when(
              data: (value) => Text(value.toString()),
              loading: () => const Text('loading'),
              error: (dynamic err, stack) => const Text('error'),
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });
  testWidgets('FutureProviderFamily works with other providers',
      (tester) async {
    final futureProvider = Provider((_) => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      final other = ref.read(futureProvider);
      return other.value * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer((c, read) {
            return read(futureProviderFamily).when(
              data: (value) => Text(value.toString()),
              loading: () => const Text('loading'),
              error: (dynamic err, stack) => const Text('error'),
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });
  testWidgets('FutureProviderFamily can be used directly', (tester) async {
    final futureProvider = Provider((_) => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      final other = ref.read(futureProvider);
      return other.value * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer((c, read) {
            return read(futureProviderFamily).when(
              data: (value) => Text(value.toString()),
              loading: () => const Text('loading'),
              error: (dynamic err, stack) => const Text('error'),
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });
}

class Listener extends Mock {
  void call(AsyncValue<int> value);
}
