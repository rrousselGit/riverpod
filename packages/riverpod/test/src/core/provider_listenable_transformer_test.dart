import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import '../../old/utils.dart';
import '../matrix.dart' as utils;
import '../utils.dart' as utils;

void main() {
  test('Simple sync example', () {
    final container = ProviderContainer.test();
    final listener = utils.Listener<String>();
    final onError = utils.ErrorListener();
    final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

    final listenable = SyncDelegatingTransformer<int, String>(
      provider,
      (context) {
        return ProviderTransformer(
          initialState: () => 'Hello ${context.sourceState.requireValue}',
          listener: (self, prev, next) {
            if (next.value == 2) {
              self.state = AsyncError('Error at 2', StackTrace.current);
            } else {
              self.state = AsyncData('Hello ${next.requireValue}');
            }
          },
        );
      },
    );

    final sub = container.listen(
      listenable,
      listener.call,
      onError: onError.call,
    );

    expect(sub.read(), 'Hello 0');
    verifyZeroInteractions(listener);

    notifier.state = 1;

    verifyOnly(listener, listener('Hello 0', 'Hello 1'));
    expect(sub.read(), 'Hello 1');
    verifyZeroInteractions(onError);

    notifier.state = 2;

    verifyNoMoreInteractions(listener);
    expect(sub.read, utils.throwsProviderException('Error at 2'));
    utils.verifyOnly(onError, onError('Error at 2', any));
  });

  test('Simple async example', () {
    final container = ProviderContainer.test();
    final listener = utils.Listener<AsyncValue<String>>();
    final onError = utils.ErrorListener();
    final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

    final listenable = AsyncDelegatingTransformer<int, String>(
      provider,
      (context) {
        return ProviderTransformer(
          initialState: () => 'Hello ${context.sourceState.requireValue}',
          listener: (self, prev, next) {
            if (next.value == 2) {
              self.state = AsyncError('Error at 2', StackTrace.current);
            } else {
              self.state = AsyncData('Hello ${next.requireValue}');
            }
          },
        );
      },
    );

    final sub = container.listen(
      listenable,
      listener.call,
      onError: onError.call,
    );

    expect(sub.read(), const AsyncData('Hello 0'));
    verifyZeroInteractions(listener);

    notifier.state = 1;

    verifyOnly(
      listener,
      listener(const AsyncData('Hello 0'), const AsyncData('Hello 1')),
    );
    expect(sub.read(), const AsyncData('Hello 1'));

    notifier.state = 2;
    verifyZeroInteractions(onError);
    verifyOnly(
      listener,
      listener(
        const AsyncData('Hello 1'),
        argThat(
          isA<AsyncError<String>>()
              .having((e) => e.error, 'error', 'Error at 2'),
        ),
      ),
    );
  });

  test('If initialState throws, init to AsyncError', () {
    final container = ProviderContainer.test();
    final provider = Provider<int>((ref) => 0);

    final listenable = AsyncDelegatingTransformer<int, String>(
      provider,
      (context) {
        return ProviderTransformer(
          initialState: () => throw Exception('Initial error'),
          listener: (self, prev, next) {
            self.state = AsyncData('Hello ${next.requireValue}');
          },
        );
      },
    );

    final sub = container.listen(listenable, (previous, next) {});

    expect(sub.read(), isA<AsyncError<String>>());
  });
  test('Supports sub.pause/sub.resume with both data and error', () {
    final container = ProviderContainer.test();
    final listener = utils.Listener<String>();
    final onError = utils.ErrorListener();
    final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

    final listenable = SyncDelegatingTransformer<int, String>(
      provider,
      (context) {
        return ProviderTransformer(
          initialState: () => 'Hello ${context.sourceState.requireValue}',
          listener: (self, prev, next) {
            if (next.value == 2) {
              self.state = AsyncError('Error at 2', StackTrace.current);
            } else {
              self.state = AsyncData('Hello ${next.requireValue}');
            }
          },
        );
      },
    );

    final sub = container.listen(
      listenable,
      listener.call,
      onError: onError.call,
    );

    expect(sub.read(), 'Hello 0');
    verifyZeroInteractions(listener);

    sub.pause();
    notifier.state = 1;

    verifyZeroInteractions(listener);
    expect(sub.read(), 'Hello 0');

    sub.resume();
    verifyOnly(listener, listener('Hello 0', 'Hello 1'));
    expect(sub.read(), 'Hello 1');

    sub.pause();
    notifier.state = 2;

    verifyNoMoreInteractions(listener);
    verifyZeroInteractions(onError);
    expect(sub.read(), 'Hello 1');

    sub.resume();

    verifyNoMoreInteractions(listener);
    utils.verifyOnly(onError, onError('Error at 2', any));
    expect(sub.read, utils.throwsProviderException('Error at 2'));
  });
  test('Passes the previous value to the listener', () {
    final container = ProviderContainer.test();
    final listener = utils.Listener<AsyncValue<int>>();
    final onError = utils.ErrorListener();
    final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

    final listenable = SyncDelegatingTransformer<int, String>(
      provider,
      (context) {
        return ProviderTransformer(
          initialState: () => 'Hello ${context.sourceState.requireValue}',
          listener: (self, prev, next) {
            listener(prev, next);
          },
        );
      },
    );

    final sub = container.listen(listenable, (a, b) {});

    notifier.state = 1;

    verifyOnly(listener, listener(const AsyncData(0), const AsyncData(1)));
  });

  group('ProviderTransformerContext', () {
    group('sourceState', () {
      test('returns the current state of the source provider', () async {
        final container = ProviderContainer.test();
        final notifier = utils.DeferredNotifier<int>((self, ref) {
          return 42;
        });
        final provider = NotifierProvider<Notifier<int>, int>(() => notifier);
        late final ProviderTransformerContext<int, String> context;

        final listenable = SyncDelegatingTransformer<int, String>(
          provider,
          (c) {
            context = c;
            return ProviderTransformer(
              initialState: () => '',
              listener: (self, prev, next) {},
            );
          },
        );

        final sub = container.listen(listenable, (a, b) {});

        expect(context.sourceState, const AsyncData(42));
        notifier.state = 50;
        expect(context.sourceState, const AsyncData(50));
      });

      test('Converts dependency error into AsyncError', () async {
        final container = ProviderContainer.test();
        late final ProviderTransformerContext<int, String> context;
        final provider = Provider<int>(
          (ref) => throw Exception('Dependency error'),
        );

        late final AsyncResult<int> initialState;

        final listenable = AsyncDelegatingTransformer<int, String>(
          provider,
          (c) {
            context = c;
            return ProviderTransformer(
              initialState: () {
                initialState = context.sourceState;
                return '';
              },
              listener: (self, prev, next) {},
            );
          },
        );

        final sub = container.listen(listenable, (a, b) {});

        expect(
          initialState,
          isA<AsyncError<int>>().having(
            (e) => e.error,
            'error',
            isException.having(
              (e) => e.toString(),
              'toString',
              'Exception: Dependency error',
            ),
          ),
        );

        container.invalidate(provider);
        await container.pump();

        expect(
          context.sourceState,
          isA<AsyncError<String>>().having(
            (e) => e.error,
            'error',
            isException.having(
              (e) => e.toString(),
              'toString',
              'Exception: Dependency error',
            ),
          ),
        );
      });
    });
  });

  test('Respect weak flag', () {});
  test('Supports both providers and other listenables as source', () {});
  test('ProviderSubscription.read reads current value, if any', () {});

  group('error handling', () {
    test('Async uncaught errors are reported to the container zone', () {});
    test('If transform throws, reports to onError', () {});
    test('If listener throws, reports to onError', () {});
    test('Setting state to ResultError notifies onError', () {});
    test('ProviderSubscription.read rethrows transformer error if any', () {});
    test('ProviderSubscription.read rethrows state error if any', () {});
  });
}

final class SyncDelegatingTransformer<InT, ValueT>
    with SyncProviderTransformerMixin<InT, ValueT> {
  SyncDelegatingTransformer(
    this.source,
    this.transformCb,
  );

  @override
  final ProviderListenable<InT> source;

  final ProviderTransformer<InT, ValueT> Function(
    ProviderTransformerContext<InT, ValueT> context,
  ) transformCb;

  @override
  ProviderTransformer<InT, ValueT> transform(
    ProviderTransformerContext<InT, ValueT> context,
  ) {
    return transformCb(context);
  }
}

final class AsyncDelegatingTransformer<InT, ValueT>
    with AsyncProviderTransformerMixin<InT, ValueT> {
  AsyncDelegatingTransformer(
    this.source,
    this.transformCb,
  );

  @override
  final ProviderListenable<InT> source;

  final ProviderTransformer<InT, ValueT> Function(
    ProviderTransformerContext<InT, ValueT> context,
  ) transformCb;

  @override
  ProviderTransformer<InT, ValueT> transform(
    ProviderTransformerContext<InT, ValueT> context,
  ) {
    return transformCb(context);
  }
}
