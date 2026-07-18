import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/misc.dart';
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

    final listenable = DelegatingListenable<int, String>(provider, () {
      return DelegatingTransformer<int, String>(
        initState: (self) => 'Hello ${self.sourceState.requireValue}',
        onEvent: (self, prev, next) {
          if (next.value == 2) {
            self.state = AsyncError('Error at 2', StackTrace.current);
          } else {
            self.state = AsyncData('Hello ${next.requireValue}');
          }
        },
      );
    });

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

  test('Supports sub.pause/sub.resume with both data and error', () {
    final container = ProviderContainer.test();
    final listener = utils.Listener<String>();
    final onError = utils.ErrorListener();
    final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);
    final listenerTransformer = utils.Listener<AsyncResult<int>>();

    final listenable = DelegatingListenable<int, String>(provider, () {
      return DelegatingTransformer<int, String>(
        initState: (self) => 'Hello ${self.sourceState.requireValue}',
        onEvent: (self, prev, next) {
          listenerTransformer(prev, next);
          if (next.value == 2) {
            self.state = AsyncError('Error at 2', StackTrace.current);
          } else {
            self.state = AsyncData('Hello ${next.requireValue}');
          }
        },
      );
    });

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
    verifyZeroInteractions(listenerTransformer);
    expect(sub.read(), 'Hello 0');

    notifier.state = 3;
    sub.resume();

    verifyOnly(
      listenerTransformer,
      listenerTransformer(const AsyncData(0), const AsyncData(3)),
    );
    verifyOnly(listener, listener('Hello 0', 'Hello 3'));
    expect(sub.read(), 'Hello 3');

    sub.pause();
    notifier.state = 2;

    verifyNoMoreInteractions(listener);
    verifyZeroInteractions(onError);
    expect(sub.read(), 'Hello 3');

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

    final listenable = DelegatingListenable<int, String>(provider, () {
      return DelegatingTransformer<int, String>(
        initState: (self) => 'Hello ${self.sourceState.requireValue}',
        onEvent: (self, prev, next) {
          listener(prev, next);
        },
      );
    });

    final sub = container.listen(listenable, (a, b) {});

    notifier.state = 1;

    verifyOnly(listener, listener(const AsyncData(0), const AsyncData(1)));
  });

  group('ProviderTransformer2', () {
    group('sourceState', () {
      test('returns the current state of the source provider', () async {
        final container = ProviderContainer.test();
        final notifier = utils.DeferredNotifier<int>((self, ref) {
          return 42;
        });
        final provider = NotifierProvider<Notifier<int>, int>(() => notifier);
        late final DelegatingTransformer<int, String> transformer;

        final listenable = DelegatingListenable<int, String>(provider, () {
          return transformer = DelegatingTransformer(
            initState: (self) => '',
            onEvent: (self, prev, next) {},
          );
        });

        final sub = container.listen(listenable, (a, b) {});

        expect(transformer.sourceState, const AsyncData(42));
        notifier.state = 50;
        expect(transformer.sourceState, const AsyncData(50));
      });

      test('Converts dependency error into AsyncError', () async {
        final container = ProviderContainer.test();
        late final DelegatingTransformer<int, String> transformer;
        final provider = Provider<int>(
          (ref) => throw Exception('Dependency error'),
        );

        late final AsyncResult<int> initialState;

        final listenable = DelegatingListenable<int, String>(provider, () {
          return transformer = DelegatingTransformer(
            initState: (self) {
              initialState = self.sourceState;
              return '';
            },
            onEvent: (self, prev, next) {},
          );
        });

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
          transformer.sourceState,
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
    var callCount = 0;
    final notifier = utils.DeferredNotifier<int>((self, ref) {
      callCount++;
      return 0;
    });
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);
    final listener = utils.Listener<AsyncValue<int>>();
    var listenableCallCount = 0;
    final listenable = DelegatingListenable<int, String>(provider, () {
      listenableCallCount++;
      return DelegatingTransformer<int, String>(
        initState: (self) => 'Hello ${self.sourceState.requireValue}',
        onEvent: (self, prev, next) {
          listener(prev, next);
          self.state = AsyncData('Hello ${next.requireValue}');
        },
      );
    });

    final sub = container.listen(listenable, (a, b) {}, weak: true);

    expect(callCount, 0);
    // createTransformer is invoked eagerly, unlike the deprecated `transform`.
    expect(listenableCallCount, 1);
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
    final listenable = DelegatingListenable<bool, String>(
      provider.select((v) => v.isEven),
      () {
        return DelegatingTransformer(
          initState: (self) => 'Hello ${self.sourceState.requireValue}',
          onEvent: (self, prev, next) {
            callCount++;
            self.state = AsyncData('Hello ${next.requireValue}');
          },
        );
      },
    );

    final sub = container.listen(listenable, (previous, next) {});

    expect(sub.read(), 'Hello true');
    expect(callCount, 0);

    notifier.state += 2;

    expect(sub.read(), 'Hello true');
    expect(callCount, 0);

    notifier.state += 1;

    expect(sub.read(), 'Hello false');
    expect(callCount, 1);
  });

  group('ProviderTransformer2', () {
    group('onClose', () {
      test('guards the listener', () {
        final errors = <Object>[];
        final container = runZonedGuarded(
          ProviderContainer.test,
          (err, _) => errors.add(err),
        )!;
        final provider = Provider<int>((ref) => 0);

        final listenable = DelegatingListenable<int, String>(provider, () {
          return DelegatingTransformer(
            initState: (self) => 'Hello',
            onEvent: (self, prev, next) {},
            onClose: () {
              throw Exception('Close error');
            },
          );
        });

        final sub = container.listen(listenable, (previous, next) {});

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

          final listenable = DelegatingListenable<int, String>(provider, () {
            return DelegatingTransformer(
              initState: (self) => 'Hello',
              onEvent: (self, prev, next) {},
              onClose: () {},
            );
          });

          final sub = container.listen(
            listenable,
            (previous, next) {},
            weak: true,
          );

          sub.close();

          expect(callCount, 0);
        },
      );

      test('triggers on the first sub.close', () {
        final container = ProviderContainer.test();
        final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
        final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

        var callCount = 0;
        final listenable = DelegatingListenable<int, String>(provider, () {
          return DelegatingTransformer(
            initState: (self) => 'Hello',
            onEvent: (self, prev, next) {},
            onClose: () {
              callCount++;
            },
          );
        });

        final sub = container.listen(listenable, (previous, next) {});

        expect(callCount, 0);
        sub.close();
        expect(callCount, 1);
        sub.close();
        expect(callCount, 1); // Should not trigger again
      });
    });
  });

  group('error handling', () {
    test('If initState throws, the initial container.listen rethrows', () {
      final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
      final provider = NotifierProvider<Notifier<int>, int>(() => notifier);
      final container = ProviderContainer.test();

      final listenable = DelegatingListenable<int, String>(provider, () {
        return DelegatingTransformer(
          initState: (self) {
            throw Exception('Error in transformer');
          },
          onEvent: (self, prev, next) {},
        );
      });

      // Unlike the deprecated `transform`, `initState` is read eagerly
      // by a non-weak `container.listen`, so the error is thrown
      // synchronously instead of going through `onError`.
      expect(
        () => container.listen(listenable, (a, b) {}),
        throwsA(
          isA<ProviderException>().having(
            (e) => e.exception.toString(),
            'exception',
            contains('Error in transformer'),
          ),
        ),
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

      final listenable = DelegatingListenable<int, String>(provider, () {
        return DelegatingTransformer(
          initState: (self) => 'Hello ${self.sourceState.requireValue}',
          onEvent: (self, prev, next) {
            throw Exception('Error in listener');
          },
        );
      });

      final sub = container.listen(listenable, (a, b) {});

      notifier.state = 1;

      expect(errors, [
        isException.having(
          (e) => e.toString(),
          'toString',
          'Exception: Error in listener',
        ),
      ]);
    });

    test('Setting state to ResultError notifies onError', () {
      final container = ProviderContainer.test();
      final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
      final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

      final listenable = DelegatingListenable<int, String>(provider, () {
        return DelegatingTransformer(
          initState: (self) => 'Hello ${self.sourceState.requireValue}',
          onEvent: (self, prev, next) {
            self.state = AsyncError('Error in listener', StackTrace.current);
          },
        );
      });

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

      final listenable = DelegatingListenable<int, String>(provider, () {
        return DelegatingTransformer(
          initState: (self) {
            throw Exception('Error in transformer');
          },
          onEvent: (self, prev, next) {},
        );
      });

      // Using `weak: true` so that `initState` isn't read eagerly, allowing
      // us to observe the error being thrown lazily from `sub.read()`.
      final sub = container.listen(
        listenable,
        (a, b) {},
        onError: (e, s) {},
        weak: true,
      );

      expect(
        sub.read,
        throwsA(
          isA<ProviderException>().having(
            (e) => e.exception.toString(),
            'exception',
            contains('Error in transformer'),
          ),
        ),
      );
    });
  });
}

final class DelegatingListenable<InT, ValueT>
    extends CustomProviderListenable<InT, ValueT> {
  DelegatingListenable(this.source, this.createTransformerCb);

  @override
  final ProviderListenable<InT> source;

  final DelegatingTransformer<InT, ValueT> Function() createTransformerCb;

  @override
  DelegatingTransformer<InT, ValueT> createTransformer() =>
      createTransformerCb();
}

final class DelegatingTransformer<InT, ValueT>
    extends
        SyncProviderTransformer2<
          InT,
          ValueT,
          DelegatingListenable<InT, ValueT>
        > {
  DelegatingTransformer({
    required ValueT Function(DelegatingTransformer<InT, ValueT> self) initState,
    required void Function(
      DelegatingTransformer<InT, ValueT> self,
      AsyncResult<InT> prev,
      AsyncResult<InT> next,
    )
    onEvent,
    void Function()? onClose,
  }) : _initState = initState,
       _onEvent = onEvent,
       _onClose = onClose;

  final ValueT Function(DelegatingTransformer<InT, ValueT> self) _initState;
  final void Function(
    DelegatingTransformer<InT, ValueT> self,
    AsyncResult<InT> prev,
    AsyncResult<InT> next,
  )
  _onEvent;
  final void Function()? _onClose;

  @override
  ValueT initState() => _initState(this);

  @override
  void onEvent(AsyncResult<InT> prev, AsyncResult<InT> next) =>
      _onEvent(this, prev, next);

  @override
  void onClose() => _onClose?.call();
}
