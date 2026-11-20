import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ContainerReadElement;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('provider.future', () {
    group('handles listen(weak: true)', () {
      test('closing the subscription updated element.weakDependents', () {
        final container = ProviderContainer.test();
        final provider = FutureProvider((ref) => 0);

        final sub = container.listen(
          provider.future,
          weak: true,
          (previous, value) {},
        );

        expect(
          container.readProviderElement(provider).weakDependents,
          isNotEmpty,
        );

        sub.close();

        expect(container.readProviderElement(provider).weakDependents, isEmpty);
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
        },
      );

      test('common use-case ', () async {
        var buildCount = 0;
        final provider = FutureProvider((ref) {
          buildCount++;
          return 'Hello';
        });
        final container = ProviderContainer.test();
        final listener = Listener<Future<String>>();

        container.listen(provider.future, listener.call, weak: true);

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

      test(
        'calling `sub.read` on a weak listener will read the value',
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
        },
      );
    });

    test('Listening to a modifier correctly fires ref life-cycles', () async {
      final container = ProviderContainer.test();
      final onDispose = OnDisposeMock();
      final onAddListener = OnAddListener();
      final onRemoveListener = OnRemoveListener();
      final onResume = OnResume();
      final onCancel = OnCancel();

      final provider = FutureProvider((ref) {
        ref.onDispose(onDispose.call);
        ref.onAddListener(onAddListener.call);
        ref.onRemoveListener(onRemoveListener.call);
        ref.onCancel(onCancel.call);
        ref.onResume(onResume.call);
        return 0;
      });

      final sub = container.listen(provider.future, (prev, value) {});

      verifyOnly(onAddListener, onAddListener());

      final sub2 = container.listen(provider.future, (prev, value) {});

      verifyOnly(onAddListener, onAddListener());

      sub.close();

      verifyOnly(onRemoveListener, onRemoveListener());
      verifyZeroInteractions(onCancel);

      sub2.close();

      verifyOnly(onRemoveListener, onRemoveListener());
      verifyZeroInteractions(onResume);
      verifyOnly(onCancel, onCancel());

      container.listen(provider.future, (prev, value) {});

      verifyOnly(onAddListener, onAddListener());
      verifyOnly(onResume, onResume());

      container.listen(provider.future, (prev, value) {});

      verifyOnly(onAddListener, onAddListener());
      verifyNoMoreInteractions(onCancel);
      verifyNoMoreInteractions(onResume);
      verifyZeroInteractions(onDispose);

      container.invalidate(provider);

      verifyOnly(onDispose, onDispose());
    });
  });
}
