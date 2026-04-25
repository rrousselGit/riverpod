import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetRef', () {
    testWidgets('read participates in action retention', (tester) async {
      final completer = Completer<int>();
      var disposed = false;
      final provider = FutureProvider.autoDispose<int>((ref) {
        ref.onDispose(() => disposed = true);
        return completer.future;
      });

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(builder: (context, ref, _) => Container()),
        ),
      );

      final ref = tester.firstElement(find.byType(Consumer)) as WidgetRef;

      final future = action(() async => ref.read(provider.future));

      await tester.pump();
      expect(disposed, false);

      completer.complete(42);

      await expectLater(future, completion(42));
      await tester.pump();

      expect(disposed, true);
    });

    testWidgets('watch throws inside action', (tester) async {
      final provider = Provider((ref) => 42);

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              action(() => ref.watch(provider));
              return Container();
            },
          ),
        ),
      );

      expect(tester.takeException(), isA<AssertionError>());
    });

    group('invalidate', () {
      testWidgets('supports asReload', (tester) async {
        final provider = FutureProvider<int>((r) async => 0);

        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(builder: (context, ref, _) => Container()),
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
