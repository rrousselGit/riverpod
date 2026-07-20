import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

Future<void> pump() => Future<void>.delayed(Duration.zero);

void main() {
  group('ProviderScheduler', () {
    // Regression test for https://github.com/rrousselGit/riverpod/issues/4808
    test('defers duplicate refreshes scheduled during a refresh pass', () async {
      final a = NotifierProvider<Counter, int>(Counter.new);
      final d = NotifierProvider<Counter, int>(Counter.new);

      // Derived provider between [a] and the listener below.
      final b = Provider<int>((ref) => ref.watch(a));

      // A listener of a derived provider that synchronously writes state
      // consumed by [e]. The refresh of [e] caused by this write must be
      // deferred because [e] already rebuilt earlier in this pass.
      final c = Provider<int>((ref) {
        ref.listen(b, (_, _) => ref.read(d.notifier).increment());
        return 0;
      });

      final e = Provider<int>((ref) => ref.watch(a) + ref.watch(d));

      final container = ProviderContainer.test();

      // Subscription order matters: e must flush before b notifies c's listener.
      container.listen(e, (_, _) {});
      container.listen(c, (_, _) {});

      container.read(a.notifier).increment();

      await pump();
      await pump();

      expect(container.read(b), 1);
      expect(container.read(e), 2);
    });
  });
}
