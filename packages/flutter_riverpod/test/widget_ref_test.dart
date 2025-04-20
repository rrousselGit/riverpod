import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetRef', () {
    group('invalidate', () {
      testWidgets('supports asReload', (tester) async {
        final provider = FutureProvider<int>((r) async => 0);

        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(
              builder: (context, ref, _) => Container(),
            ),
          ),
        );

        final ref = tester.firstElement(find.byType(Consumer)) as WidgetRef;

        await ref.read(provider.future);
        expect(ref.read(provider), const AsyncValue.data(0));

        ref.invalidate(provider, asReload: true);

        expect(
          ref.read(provider),
          isA<AsyncLoading<int>>().having((e) => e.value, 'value', 0),
        );
      });
    });
  });
}
