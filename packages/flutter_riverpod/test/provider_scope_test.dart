import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProviderScope', () {
    group('retry', () {
      testWidgets('passes the value to the ProviderContainer', (tester) async {
        Duration? retry(int count, Object error) => Duration.zero;

        await tester.pumpWidget(
          ProviderScope(retry: retry, child: Container()),
        );

        final element = tester.element(find.byType(Container));
        final container = ProviderScope.containerOf(element);

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

        final element = tester.element(find.byType(Container));
        final container = ProviderScope.containerOf(element);

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
