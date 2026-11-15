import 'package:riverpod/misc.dart' show KeepAliveLink;
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderScheduler', () {
    group('disposing an element that was already disposed (#4806)', () {
      test('does not dispose the new element when closing the KeepAliveLink '
          'of the previous one', () async {
        final container = ProviderContainer.test();
        final links = <KeepAliveLink>[];
        var disposeCount = 0;
        final provider = Provider.autoDispose((ref) {
          links.add(ref.keepAlive());
          ref.onDispose(() => disposeCount++);
          return 0;
        });

        container.read(provider);
        // Drops the link without closing it, then disposes the element.
        container.invalidate(provider);
        await container.pump();
        expect(container.exists(provider), false);
        expect(disposeCount, 1);

        final sub = container.listen(provider, (_, _) {});
        links.first.close();
        await container.pump();

        expect(sub.closed, false);
        expect(sub.read(), 0);
        expect(disposeCount, 1);
      });

      test('does not dispose the new element when the previous one was '
          'scheduled twice', () async {
        final container = ProviderContainer.test();
        final provider = Provider.autoDispose((ref) => 0);
        ProviderSubscription<int>? sub;
        final other = Provider.autoDispose((ref) {
          ref.onDispose(() => sub = container.listen(provider, (_, _) {}));
          return 0;
        });

        // Dispose queue: [provider, other, provider]
        container.read(provider);
        container.read(other);
        container.read(provider);
        await container.pump();

        expect(sub!.closed, false);
        expect(sub!.read(), 0);
      });

      test('still disposes the new element once it is unused', () async {
        final container = ProviderContainer.test();
        final links = <KeepAliveLink>[];
        final provider = Provider.autoDispose((ref) {
          links.add(ref.keepAlive());
          return 0;
        });

        container.read(provider);
        container.invalidate(provider);
        await container.pump();

        final sub = container.listen(provider, (_, _) {});
        links.first.close();
        await container.pump();

        sub.close();
        await container.pump();
        expect(container.exists(provider), true);

        links.last.close();
        await container.pump();
        expect(container.exists(provider), false);
      });
    });
  });
}
