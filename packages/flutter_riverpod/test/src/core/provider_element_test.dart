import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'provider_subscription_test.dart';

void main() {
  testWidgets('invalidating an unlistened keepAlive graph then re-watching it '
      'during build must neither throw nor freeze the scheduler', (
    tester,
  ) async {
    // https://github.com/rrousselGit/riverpod/issues/4812
    var count = 0;
    final counterProvider = NotifierProvider<DeferredNotifier<int>, int>(
      () => DeferredNotifier((ref, self) => count),
    );
    final parentProvider = Provider<int>((ref) => ref.watch(counterProvider));
    final childAProvider = Provider<int>((ref) => ref.watch(parentProvider));
    final childBProvider = Provider<int>((ref) => ref.watch(parentProvider));

    Widget pageA() {
      return Consumer(
        builder: (context, ref, _) {
          final a = ref.watch(childAProvider);
          final b = ref.watch(childBProvider);
          return Text('a=$a b=$b', textDirection: TextDirection.ltr);
        },
      );
    }

    // 1. Mount and activate the graph (a page watches it).
    await tester.pumpWidget(ProviderScope(child: pageA()));
    final container = tester.container();

    expect(find.text('a=0 b=0'), findsOneWidget);

    // 2. Navigate away: no listener left -> the keepAlive graph is inactive.
    await tester.pumpWidget(const ProviderScope(child: SizedBox()));

    // 3. The root dependency changes while the graph is unlistened. The
    //    refresh task runs, but skips the inactive elements: the graph
    //    stays dirty.
    count++;
    container.invalidate(counterProvider);
    await tester.pump();

    // 4. Navigate back: PageA.build re-watches the stale graph.
    await tester.pumpWidget(ProviderScope(child: pageA()));
    expect(find.text('a=1 b=1'), findsOneWidget);

    // 5. The scheduler must still be functional afterwards.
    count++;
    container.invalidate(counterProvider);
    await tester.pump();
    await tester.pump();

    expect(container.read(counterProvider), 2);
    expect(
      find.text('a=2 b=2'),
      findsOneWidget,
      reason:
          'scheduler is frozen: the providers were invalidated but '
          'never rebuilt',
    );
  });

  testWidgets(
    'resuming a TickerMode consumer with a diamond dependency does not throw',
    (tester) async {
      // https://github.com/rrousselGit/riverpod/issues/4882
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final seed = NotifierProvider<DeferredNotifier<int>, int>(
        () => DeferredNotifier((ref, self) => 0),
      );
      final shared = Provider<int>((ref) => ref.watch(seed));
      final left = Provider<int>((ref) => ref.watch(shared) + 1);
      final rightLeaf = Provider<int>((ref) => ref.watch(shared) * 2);
      final right = Provider<int>((ref) => ref.watch(rightLeaf));
      final top = Provider<int>(
        (ref) => ref.watch(left) + ref.watch(right),
      );

      Widget app({required bool enabled}) {
        return UncontrolledProviderScope(
          container: container,
          child: TickerMode(
            enabled: enabled,
            child: Consumer(
              builder: (context, ref, _) {
                final value = ref.watch(top);
                return Text('$value', textDirection: TextDirection.ltr);
              },
            ),
          ),
        );
      }

      await tester.pumpWidget(app(enabled: true));
      expect(find.text('1'), findsOneWidget);

      await tester.pumpWidget(app(enabled: false));
      container.read(seed.notifier).state++;

      await tester.pumpWidget(app(enabled: true));
      expect(find.text('4'), findsOneWidget);

      container.read(seed.notifier).state++;
      await tester.pump();
      expect(find.text('7'), findsOneWidget);
    },
  );
}
