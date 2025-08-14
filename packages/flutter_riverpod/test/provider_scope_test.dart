import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProviderScope', () {
    testWidgets(
        'If ProviderScope does not rebuild after a few frames, flush the scheduler',
        (tester) async {
      var result = 'Hello World';
      final provider = Provider((ref) => result);

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              return Text(
                ref.watch(provider),
                textDirection: TextDirection.ltr,
              );
            },
          ),
        ),
      );
      final container = tester.container();

      late String value;
      container.listen(
        provider,
        (previous, next) => value = next,
        fireImmediately: true,
      );

      result = 'Hello Foo';
      container.invalidate(provider);

      expect(value, 'Hello World');

      await tester.idle();

      expect(value, 'Hello Foo');
    });

    testWidgets(
        'Supports scheduling rebuilds of a scoped provider '
        'from an ancestor scope update', (tester) async {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/3498
      final futureProvider = FutureProvider.autoDispose<int>(
        (ref) async {
          await null;
          return 42;
        },
        name: 'futureProvider',
      );

      final secondProvider = Provider.autoDispose<int?>(
        (ref) => ref.watch(futureProvider).value,
        name: 'secondProvider',
      );

      final combinedProvider = Provider.autoDispose<int?>(
        (ref) => ref.watch(secondProvider),
        name: 'combinedProvider',
      );

      const key = Key('Widget1');
      final widget1 = Consumer(
        key: key,
        builder: (context, ref, _) {
          final isCombined = ref.watch(combinedProvider) != null;
          return Text('is combined? $isCombined');
        },
      );
      final widget2 = Consumer(
        builder: (context, ref, _) {
          final combined = ref.watch(combinedProvider);
          final second = ref.watch(secondProvider);
          return Text('second: $second, combined $combined');
        },
      );
      final app = MaterialApp(
        home: ProviderScope(
          overrides: [combinedProvider],
          child: Scaffold(body: Column(children: [widget1, widget2])),
        ),
      );

      await tester.pumpWidget(ProviderScope(child: app));

      expect(find.text('is combined? false'), findsOneWidget);

      final container = tester.container(of: find.byKey(key));
      await container.read(futureProvider.future);
      await tester.pump();

      expect(find.text('is combined? true'), findsOneWidget);
      expect(find.text('second: 42, combined 42'), findsOneWidget);
    });

    group('retry', () {
      testWidgets('passes the value to the ProviderContainer', (tester) async {
        Duration? retry(int count, Object error) => Duration.zero;

        await tester.pumpWidget(
          ProviderScope(retry: retry, child: Container()),
        );

        final container = tester.container();

        expect(container.retry, retry);
      });

      testWidgets('works in widget tests', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            retry: (retryCount, error) => const Duration(milliseconds: 10),
            child: Container(),
          ),
        );
        var buildCount = 0;
        final provider = Provider((ref) {
          buildCount++;
          throw Exception();
        });

        final container = tester.container();

        container.listen(provider, (a, b) {}, onError: (err, stack) {});

        expect(buildCount, 1);

        await tester.pump(const Duration(milliseconds: 10));

        expect(buildCount, 2);
      });
    });

    group('tester helpers finds container from a pumped ProviderScope', () {
      testWidgets('using default lookup', (tester) async {
        await tester.pumpWidget(const ProviderScope(child: Placeholder()));
        expect(tester.container(), isA<ProviderContainer>());

        await tester.pumpWidget(
          Builder(
            builder: (context) {
              return const Column(
                children: [
                  ProviderScope(child: Placeholder()),
                ],
              );
            },
          ),
        );
        expect(
          tester.container(),
          isA<ProviderContainer>(),
          reason: 'the helper method should find the container'
              ' in a scope that is not the first widget',
        );
      });

      testWidgets('from a ProviderScope using of', (tester) async {
        await tester.pumpWidget(const ProviderScope(child: Placeholder()));

        expect(
          tester.container(of: find.byType(Placeholder)),
          isA<ProviderContainer>(),
        );

        const innerKey = Key('inner');
        const outerKey = Key('outer');

        final outerContainer = ProviderContainer.test();
        final innerContainer = ProviderContainer.test();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: outerContainer,
            child: Container(
              key: outerKey,
              child: UncontrolledProviderScope(
                container: innerContainer,
                child: Container(
                  key: innerKey,
                ),
              ),
            ),
          ),
        );

        expect(tester.container(of: find.byKey(innerKey)), innerContainer);
        expect(tester.container(of: find.byKey(outerKey)), outerContainer);
      });
    });
  });
}
