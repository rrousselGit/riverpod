import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('provider.future', () {
    group('handles listen(weak: true)', () {
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
