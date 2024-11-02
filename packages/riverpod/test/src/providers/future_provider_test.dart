import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../utils.dart';

void main() {
  group('FutureProvider', () {
    group('retry', () {
      test(
        'handles retry',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          var err = Exception('foo');
          final stack = StackTrace.current;
          final provider = FutureProvider<int>(
            (ref) => Error.throwWithStackTrace(err, stack),
            retry: (_, __) => const Duration(seconds: 1),
          );
          final listener = Listener<AsyncValue<int>>();

          container.listen(provider, fireImmediately: true, listener.call);
          await container.read(provider.future).catchError((e) => 0);

          verifyOnly(
            listener,
            listener(any, AsyncValue<int>.error(err, stack)),
          );

          err = Exception('bar');

          fake.elapse(const Duration(seconds: 1));
          fake.flushMicrotasks();

          await container.read(provider.future).catchError((e) => 0);

          verifyOnly(
            listener,
            listener(any, AsyncValue<int>.error(err, stack)),
          );
        }),
      );
    });
  });
}
