import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

// All keepAlive (non-autoDispose), like repositories/services in a real app.
// Fork topology: two dependents of a shared parent.
final counterProvider = NotifierProvider<Counter, int>(Counter.new);
final parentProvider = Provider<int>((ref) => ref.watch(counterProvider));
final childAProvider = Provider<int>((ref) => ref.watch(parentProvider));
final childBProvider = Provider<int>((ref) => ref.watch(parentProvider));

class PageA extends ConsumerWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(childAProvider);
    final b = ref.watch(childBProvider);
    return Text('a=$a b=$b', textDirection: TextDirection.ltr);
  }
}

void main() {
  // Regression test for https://github.com/rrousselGit/riverpod/issues/4812
  // and https://github.com/rrousselGit/riverpod/issues/4805.
  testWidgets('invalidating an unlistened keepAlive graph then re-watching it '
      'during build must neither throw nor freeze the scheduler', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    Widget app(Widget child) =>
        UncontrolledProviderScope(container: container, child: child);

    // 1. Mount and activate the graph (a page watches it).
    await tester.pumpWidget(app(const PageA()));
    expect(find.text('a=0 b=0'), findsOneWidget);

    // 2. Navigate away: no listener left -> the keepAlive graph is
    //    inactive.
    await tester.pumpWidget(app(const SizedBox()));

    // 3. The root dependency changes while the graph is unlistened. The
    //    refresh task runs, but skips the inactive elements: the graph
    //    stays dirty.
    container.read(counterProvider.notifier).increment();
    await tester.pump();

    // 4. Navigate back: PageA.build re-watches the stale graph. The
    //    shared parent flushes in place and synchronously notifies its
    //    other dependent, whose invalidateSelf reaches
    //    _UncontrolledProviderScopeState.scheduleRefresh while PageA is
    //    building. This must not call setState() during build.
    await tester.pumpWidget(app(const PageA()));
    expect(find.text('a=1 b=1'), findsOneWidget);

    // 5. The scheduler must still be functional afterwards.
    container.read(counterProvider.notifier).increment();
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
}
