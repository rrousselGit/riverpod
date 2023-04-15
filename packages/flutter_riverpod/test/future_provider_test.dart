import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  test('SynchronousFuture', () {
    final futureProvider = FutureProvider((_) => SynchronousFuture(42));
    final container = createContainer();

    expect(container.read(futureProvider), const AsyncValue.data(42));
  });

  testWidgets('updates dependents with value', (tester) async {
    final futureProvider = FutureProvider((s) async => 42);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          child: Consumer(
            builder: (c, ref, _) {
              return ref.watch(futureProvider).when(
                    data: (data) => Text(data.toString()),
                    loading: () => const Text('loading'),
                    error: (err, stack) => Text('$err'),
                  );
            },
          ),
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

    Object? whenError;
    StackTrace? whenStack;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          child: Consumer(
            builder: (c, ref, _) {
              return ref.watch(futureProvider).when(
                    data: (data) => Text(data.toString()),
                    loading: () => const Text('loading'),
                    error: (err, stack) {
                      whenError = err;
                      whenStack = stack;
                      return const Text('error');
                    },
                  );
            },
          ),
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
        child: Consumer(
          builder: (c, ref, _) {
            ref.watch(futureProvider);
            return Container();
          },
        ),
      ),
    );

    // unmount ProviderScope which disposes the provider
    await tester.pumpWidget(Container());

    completer.complete(42);

    // wait for then to tick
    await Future<void>.value();
  });

  testWidgets("future fails after unmount does't crash", (tester) async {
    final completer = Completer<int>();
    final futureProvider = FutureProvider((s) => completer.future);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            ref.watch(futureProvider);
            return Container();
          },
        ),
      ),
    );

    // unmount ProviderScope which disposes the provider
    await tester.pumpWidget(Container());

    final error = Error();
    completer.completeError(error);

    // wait for onError to tick
    await Future<void>.value();
  });

  group('overrideWithValue', () {
    // var callCount = 0;
    // final futureProvider = FutureProvider((s) async {
    //   callCount++;
    //   return 42;
    // });

    // Future<int>? future;
    // var completed = false;
    // final proxy = Provider<String>(
    //   (ref) {
    //     final first = ref.watch(futureProvider.future);
    //     future = first
    //       ..then(
    //         (value) => completed = true,
    //         onError: (dynamic _) => completed = true,
    //       );
    //     return '';
    //   },
    // );

    // setUp(() {
    //   callCount = 0;
    //   completed = false;
    //   future = null;
    // });

    // final child = Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: Consumer(builder: (c, ref, _) {
    //     ref.watch(proxy);
    //     return ref.watch(futureProvider).when(
    //           data: (data) => Text(data.toString()),
    //           loading: () => const Text('loading'),
    //           error: (err, stack) {
    //             return const Text('error');
    //           },
    //         );
    //   }),
    // );

    //   testWidgets('no-op if completed and rebuild with same value',
    //       (tester) async {
    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.data(42)),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     expect(completed, true);
    //     await expectLater(future, completion(42));

    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.data(42)),
    //         ],
    //         child: child,
    //       ),
    //     );
    //   });

    //   testWidgets(
    //       'FutureProviderDependency.future completes on rebuild with data',
    //       (tester) async {
    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.loading()),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     // make sure the future doesn't just complete in one frame
    //     await Future<void>.value();

    //     expect(completed, false);
    //     expect(future, isNotNull);

    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.data(42)),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     expect(completed, true);
    //     await expectLater(future, completion(42));
    //   });

    //   testWidgets(
    //       'FutureProviderDependency.future completes on rebuild with error',
    //       (tester) async {
    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.loading()),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     // make sure the future doesn't just complete in one frame
    //     await Future<void>.value();

    //     expect(completed, false);
    //     expect(future, isNotNull);

    //     final error = Error();
    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(AsyncValue.error(error)),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     expect(completed, true);
    //     await expectLater(future, throwsA(error));
    //   });

    //   testWidgets('FutureProviderDependency.future loading to loading is no-op',
    //       (tester) async {
    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.loading()),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     expect(completed, false);
    //     expect(future, isNotNull);

    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.loading()),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     // make sure the future doesn't just complete in one frame
    //     await Future<void>.value();

    //     expect(completed, false);
    //     expect(future, isNotNull);
    //   });

    //   testWidgets('Initial build as loading', (tester) async {
    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.loading()),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     expect(callCount, 0);
    //     expect(find.text('loading'), findsOneWidget);

    //     expect(completed, false);
    //     expect(future, isNotNull);
    //   });

    //   testWidgets('Initial build as value', (tester) async {
    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(const AsyncValue.data(42)),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     expect(callCount, 0);
    //     expect(find.text('42'), findsOneWidget);

    //     expect(completed, true);
    //     await expectLater(future, completion(42));
    //   });

    //   testWidgets('Initial build as error', (tester) async {
    //     final error = Error();

    //     await tester.pumpWidget(
    //       ProviderScope(
    //         overrides: [
    //           futureProvider.overrideWithValue(AsyncValue.error(error)),
    //         ],
    //         child: child,
    //       ),
    //     );

    //     expect(callCount, 0);
    //     expect(find.text('error'), findsOneWidget);

    //     expect(completed, true);
    //     await expectLater(future, throwsA(error));
    //   });
  });

  testWidgets('FutureProvider into FutureProviderFamily', (tester) async {
    final futureProvider = FutureProvider((_) async => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      final other = ref.watch(futureProvider.future);
      return await other * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer(
            builder: (c, ref, _) {
              return ref.watch(futureProviderFamily).when(
                    data: (value) => Text(value.toString()),
                    loading: () => const Text('loading'),
                    error: (err, stack) => const Text('error'),
                  );
            },
          ),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });

  testWidgets('FutureProviderFamily works with other providers',
      (tester) async {
    final provider = Provider((_) => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      return ref.watch(provider) * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer(
            builder: (c, ref, _) {
              return ref.watch(futureProviderFamily).when(
                    data: (value) => Text(value.toString()),
                    loading: () => const Text('loading'),
                    error: (err, stack) => const Text('error'),
                  );
            },
          ),
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
      final other = ref.watch(futureProvider);
      return other * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer(
            builder: (c, ref, _) {
              return ref.watch(futureProviderFamily).when(
                    data: (value) => Text(value.toString()),
                    loading: () => const Text('loading'),
                    error: (err, stack) => const Text('error'),
                  );
            },
          ),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });
}
