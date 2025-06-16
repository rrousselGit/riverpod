import 'dart:async';

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
          initState: (self) => 'Hello ${context.sourceState.requireValue}',
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
          initState: (self) => 'Hello ${context.sourceState.requireValue}',
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

  test('If initState throws, init to AsyncError', () {
    final container = ProviderContainer.test();
    final provider = Provider<int>((ref) => 0);

    final listenable = AsyncDelegatingTransformer<int, String>(
      provider,
      (context) {
        return ProviderTransformer(
          initState: (self) => throw Exception('Initial error'),
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
          initState: (self) => 'Hello ${context.sourceState.requireValue}',
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
          initState: (self) => 'Hello ${context.sourceState.requireValue}',
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
              initState: (self) => '',
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
              initState: (self) {
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
      });
    });
  });

  test('Respect weak flag', () async {
    final container = ProviderContainer.test();
    int callCount = 0;
    final notifier = utils.DeferredNotifier<int>((self, ref) {
      callCount++;
      return 0;
    });
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);
    final listener = utils.Listener<AsyncValue<int>>();
    var listenableCallCount = 0;
    final listenable = SyncDelegatingTransformer<int, String>(
      provider,
      (context) {
        listenableCallCount++;
        return ProviderTransformer(
          initState: (self) => 'Hello ${context.sourceState.requireValue}',
          listener: (self, prev, next) {
            listener(prev, next);
            self.state = AsyncData('Hello ${next.requireValue}');
          },
        );
      },
    );

    final sub = container.listen(
      listenable,
      (a, b) {},
      weak: true,
    );

    expect(callCount, 0);
    expect(listenableCallCount, 0);
    verifyZeroInteractions(listener);

    container.listen(provider, (a, b) {});

    expect(callCount, 1);
    expect(listenableCallCount, 1);
    expect(sub.read(), 'Hello 0');
    expect(callCount, 1);
    expect(listenableCallCount, 1);
    // Initial state does not trigger the listener
    verifyZeroInteractions(listener);

    notifier.state++;

    verifyOnly(listener, listener(const AsyncData(0), const AsyncData(1)));
  });

  test('Supports other listenables as source', () {
    final container = ProviderContainer.test();
    final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);
    var callCount = 0;
    final listenable = SyncDelegatingTransformer<bool, String>(
      provider.select((v) => v.isEven),
      (context) {
        return ProviderTransformer(
          initState: (self) => 'Hello ${context.sourceState.requireValue}',
          listener: (self, prev, next) {
            callCount++;
            self.state = AsyncData('Hello ${next.requireValue}');
          },
        );
      },
    );

    final sub = container.listen(
      listenable,
      (previous, next) {},
    );

    expect(sub.read(), 'Hello true');
    expect(callCount, 0);

    notifier.state += 2;

    expect(sub.read(), 'Hello true');
    expect(callCount, 0);

    notifier.state += 1;

    expect(sub.read(), 'Hello false');
    expect(callCount, 1);
  });

  group('ProviderTransformer', () {
    group('onClose', () {
      test('guards the listener', () {
        final errors = <Object>[];
        final container = runZonedGuarded(
          ProviderContainer.test,
          (err, _) => errors.add(err),
        )!;
        final provider = Provider<int>((ref) => 0);

        final listenable = SyncDelegatingTransformer<int, String>(
          provider,
          (context) {
            return ProviderTransformer(
              initState: (self) => 'Hello',
              listener: (self, prev, next) {},
              onClose: () {
                throw Exception('Close error');
              },
            );
          },
        );

        final sub = container.listen(
          listenable,
          (previous, next) {},
        );

        sub.close();

        expect(errors, [isException]);
        expect(sub.closed, isTrue);
      });

      test(
          'does not trigger the listened provider if weak but not yet initialized',
          () {
        final container = ProviderContainer.test();
        var callCount = 0;
        final provider = Provider<int>((ref) {
          callCount++;
          return 0;
        });

        final listenable = SyncDelegatingTransformer<int, String>(
          provider,
          (context) {
            return ProviderTransformer(
              initState: (self) => 'Hello',
              listener: (self, prev, next) {},
              onClose: () {},
            );
          },
        );

        final sub = container.listen(
          listenable,
          (previous, next) {},
          weak: true,
        );

        sub.close();

        expect(callCount, 0);
      });

      test('triggers on the first sub.close', () {
        final container = ProviderContainer.test();
        final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
        final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

        var callCount = 0;
        final listenable = SyncDelegatingTransformer<int, String>(
          provider,
          (context) {
            return ProviderTransformer(
              initState: (self) => 'Hello',
              listener: (self, prev, next) {},
              onClose: () {
                callCount++;
              },
            );
          },
        );

        final sub = container.listen(
          listenable,
          (previous, next) {},
        );

        expect(callCount, 0);
        sub.close();
        expect(callCount, 1);
        sub.close();
        expect(callCount, 1); // Should not trigger again
      });
    });
  });

  group('error handling', () {
    test('If transform throws, reports to onError', () {
      final errors = <Object>[];
      final container = runZonedGuarded(
        ProviderContainer.test,
        (err, _) => errors.add(err),
      )!;
      final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
      final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

      final listenable = AsyncDelegatingTransformer<int, String>(
        provider,
        (context) {
          throw Exception('Error in transformer');
        },
      );

      final sub = container.listen(listenable, (a, b) {});
      notifier.state = 1;

      expect(
        errors,
        [
          isException.having(
            (e) => e.toString(),
            'toString',
            'Exception: Error in transformer',
          ),
        ],
      );
    });

    test('If listener throws, reports to onError', () {
      final errors = <Object>[];
      final container = runZonedGuarded(
        ProviderContainer.test,
        (err, _) => errors.add(err),
      )!;
      final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
      final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

      final listenable = SyncDelegatingTransformer<int, String>(
        provider,
        (context) {
          return ProviderTransformer(
            initState: (self) => 'Hello ${context.sourceState.requireValue}',
            listener: (self, prev, next) {
              throw Exception('Error in listener');
            },
          );
        },
      );

      final sub = container.listen(listenable, (a, b) {});

      notifier.state = 1;

      expect(
        errors,
        [
          isException.having(
            (e) => e.toString(),
            'toString',
            'Exception: Error in listener',
          ),
        ],
      );
    });

    test('Setting state to ResultError notifies onError', () {
      final container = ProviderContainer.test();
      final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
      final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

      final listenable = SyncDelegatingTransformer<int, String>(
        provider,
        (context) {
          return ProviderTransformer(
            initState: (self) => 'Hello ${context.sourceState.requireValue}',
            listener: (self, prev, next) {
              self.state = AsyncError('Error in listener', StackTrace.current);
            },
          );
        },
      );

      final onError = utils.ErrorListener();
      final sub = container.listen(
        listenable,
        (a, b) {},
        onError: onError.call,
      );

      verifyZeroInteractions(onError);

      notifier.state = 1;

      utils.verifyOnly(onError, onError('Error in listener', any));
    });

    test('ProviderSubscription.read returns transformer error', () {
      final container = ProviderContainer.test();
      final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
      final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

      final listenable = AsyncDelegatingTransformer<int, String>(
        provider,
        (context) {
          throw Exception('Error in transformer');
        },
      );

      final sub = container.listen(listenable, (a, b) {}, onError: (e, s) {});
      notifier.state = 1;

      expect(
        sub.read(),
        isA<AsyncError<String>>().having(
          (e) => e.error,
          'error',
          isException.having(
            (e) => e.toString(),
            'toString',
            contains('Error in transformer'),
          ),
        ),
      );
    });
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
