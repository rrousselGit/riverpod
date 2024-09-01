import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('provider.future', () {
    group('handles listen(weak: true)', () {
      test('closing the subscription updated element.hasListeners', () {
        final container = ProviderContainer.test();
        final provider = FutureProvider((ref) => 0);

        final sub = container.listen(
          provider.future,
          weak: true,
          (previous, value) {},
        );

        expect(container.readProviderElement(provider).hasListeners, false);

        sub.close();

        expect(container.readProviderElement(provider).hasListeners, false);
      });

      test(
          'calls mayNeedDispose in ProviderSubscription.read for the sake of listen(weak: true)',
          () async {
        final container = ProviderContainer.test();
        final onDispose = OnDisposeMock();
        final provider = FutureProvider.autoDispose((ref) {
          ref.onDispose(onDispose.call);
          return 0;
        });

        final element = container.readProviderElement(provider);

        final sub = container.listen(
          provider.future,
          weak: true,
          (previous, value) {},
        );

        expect(sub.read(), completion(0));
        verifyZeroInteractions(onDispose);

        await container.pump();

        verifyOnly(onDispose, onDispose());
      });

      test('common use-case ', () async {
        var buildCount = 0;
        final provider = FutureProvider((ref) {
          buildCount++;
          return 'Hello';
        });
        final container = ProviderContainer.test();
        final listener = Listener<Future<String>>();

        container.listen(
          provider.future,
          listener.call,
          weak: true,
        );

        verifyZeroInteractions(listener);
        expect(buildCount, 0);

        container.read(provider);

        expect(buildCount, 1);
        final [future as Future<String>] = verifyOnly(
          listener,
          listener.call(argThat(isNull), captureAny),
        ).captured;
        expect(await future, 'Hello');
      });

      test('calling `sub.read` on a weak listener will read the value',
          () async {
        final provider = FutureProvider((ref) => 'Hello');
        final container = ProviderContainer.test();
        final listener = Listener<Future<String>>();

        final sub = container.listen(
          provider.future,
          listener.call,
          weak: true,
        );

        verifyZeroInteractions(listener);

        expect(await sub.read(), 'Hello');

        final [future as Future<String>] = verifyOnly(
          listener,
          listener.call(argThat(isNull), captureAny),
        ).captured;

        expect(await future, 'Hello');
      });
    });
  });
}
