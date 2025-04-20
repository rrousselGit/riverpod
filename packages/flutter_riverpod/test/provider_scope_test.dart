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
          throw UnimplementedError();
        });

        final element = tester.element(find.byType(Container));
        final container = ProviderScope.containerOf(element);

        container.listen(provider, (a, b) {}, onError: (err, stack) {});

        expect(buildCount, 1);

        await tester.pump(const Duration(milliseconds: 10));

        expect(buildCount, 2);
      });
    });
  });
}
