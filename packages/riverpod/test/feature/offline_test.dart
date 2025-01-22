import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/common/tenable.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../src/matrix.dart';
import '../src/matrix.dart' as $matrix;
import '../src/utils.dart';

void main() {
  group('Offline', () {
    test('Does not persist if the notifier does not implement NotifierEncoder',
        () {
      final provider = NotifierProvider<$matrix.DeferredNotifier<int>, int>(
        () => $matrix.DeferredNotifier<int>((ref, self) => 0),
      );
      final persist = PersistMock<Object?, Object?>();
      final container = ProviderContainer.test(persistOptions: persist);

      expect(container.read(provider).valueOf, 0);

      verifyZeroInteractions(persist);
    });

    test(
        'Throws if a notifier does not implement NotifierEncoder yet persist is specified on the provider',
        () {
      final provider = NotifierProvider<$matrix.DeferredNotifier<int>, int>(
        () => $matrix.DeferredNotifier<int>((ref, self) => 0),
        persistOptions: DelegatingPersist(read: (_) => (42,)),
      );
      final persist = PersistMock<Object?, Object?>();
      final container = ProviderContainer.test();

      final errors = <Object>[];
      runZonedGuarded(
        () => container.read(provider),
        (e, s) => errors.add(e),
      );

      expect(errors, [
        isStateError.having(
          (e) => e.message,
          'message',
          contains('NotifierEncoder'),
        ),
      ]);
    });

    matrix.createGroup((factory) {
      test(
        'When a provider is overridden, keep using the default implementation for persistence',
        () {},
      );

      test('Persist if the notifier implements NotifierEncoder', () {
        final persist = PersistMock<Object?, Object?>();
        final provider = factory.simpleProvider(
          (ref, self) => 0,
          persistOptions: persist,
        );
        final container = ProviderContainer.test();

        container.read(provider);

        verify(persist.read('key')).called(1);
        verify(persist.write('key', 0)).called(1);

        verifyNoMoreInteractions(persist);
      });

      test('throws if two providers have the same persistKey', () {
        final container = ProviderContainer.test(
          persistOptions: DelegatingPersist(read: (_) => (42,)),
        );
        final a = factory.simpleProvider(
          (ref, self) => 0,
          persistKey: (_) => 'myKey',
        );
        final b = factory.simpleProvider(
          (ref, self) => 0,
          persistKey: (_) => 'myKey',
        );

        container.read(a);

        final errors = <Object>[];
        runZonedGuarded(
          () => container.read(b),
          (e, s) => errors.add(e),
        );

        expect(errors, hasLength(2), reason: 'One for encode, one for decode');
        expect(
          errors,
          everyElement(
            isAssertionError.having(
              (e) => e.message,
              'message',
              allOf(
                contains('myKey'),
                contains(a.toString()),
                contains(b.toString()),
              ),
            ),
          ),
        );
      });

      test('Reports decoding/encoding errors to the zone', () async {
        final provider = factory.simpleProvider(
          (ref, self) => 0,
          persistOptions: DelegatingPersist(
            read: (_) => throw StateError('read'),
            write: (_, __) => throw StateError('write'),
            delete: (_) => throw StateError('delete'),
          ),
        );
        final container = ProviderContainer.test();

        final errors = <Object>[];
        runZonedGuarded(
          () {
            container.read(provider);
          },
          (e, s) => errors.add(e),
        );

        await null;

        expect(errors, [
          isA<StateError>().having((e) => e.message, 'message', 'read'),
          isA<StateError>().having((e) => e.message, 'message', 'write'),
        ]);
        errors.clear();

        if (factory.isAsync) {
          runZonedGuarded(
            () {
              container.read(provider.notifier!).state =
                  const AsyncError<Object?>(42, StackTrace.empty);
            },
            (e, s) => errors.add(e),
          );

          await null;

          expect(
            errors.single,
            isA<StateError>().having((e) => e.message, 'message', 'delete'),
          );
        }
      });

      test('Can specify an adapter on $ProviderContainer', () async {
        final provider = factory.simpleProvider(
          (ref, self) => self.state.valueOf,
        );
        final container = ProviderContainer.test(
          persistOptions: DelegatingPersist(
            read: (_) => (42,),
          ),
        );

        final sub = container.listen(provider, (a, b) {});

        expect(container.read(provider).valueOf, 42);
      });

      test('Providers can specify their adapter', () async {
        final provider = factory.simpleProvider(
          (ref, self) => self.state.valueOf,
          persistOptions: DelegatingPersist(
            read: (_) => (42,),
          ),
        );
        final container = ProviderContainer.test();

        final sub = container.listen(provider, (a, b) {});

        expect(container.read(provider).valueOf, 42);
      });

      test('Adapters support synchronously emitting values from the DB', () {
        Object? value;
        final provider = factory.simpleProvider(
          (ref, self) => value = self.valueOf,
          persistOptions: DelegatingPersist(
            read: (_) => (21,),
          ),
        );
        final container = ProviderContainer.test();

        container.listen(provider, (a, b) {});

        expect(value, 21);
      });

      group('decode', () {
        test('Rebuilding a provider does not re-initialize the value from DB',
            () async {
          var value = 42;
          final provider = factory.simpleProvider(
            (ref, self) => self.valueOf,
            persistOptions: DelegatingPersist(
              read: (_) => (value,),
            ),
          );
          final container = ProviderContainer.test();

          final sub = container.listen(provider, (a, b) {});

          value = 21;
          container.refresh(provider);

          expect(container.read(provider).valueOf, 42);
        });

        if (factory.isAsync) {
          test(
              'Rebuilding a provider that is still in AsyncLoading() aborts the DB decoding',
              () async {
            final value = Completer<int>();
            final completer = Completer<(int,)>();
            final provider = factory.simpleProvider(
              (ref, self) => value.future,
              persistOptions: DelegatingPersist(
                read: (_) => completer.future,
              ),
            );
            final container = ProviderContainer.test();

            final sub = container.listen(provider, (a, b) {});

            container.refresh(provider);
            completer.complete((42,));

            expect(container.read(provider.future!), completion(21));

            value.complete(21);
          });
        }

        if (factory.isAsync) {
          test('Adapters support asynchronously emitting values from the DB',
              () async {
            final provider = factory.simpleProvider(
              (ref, self) => self.future,
              persistOptions: DelegatingPersist(
                read: (_) => Future(() => (21,)),
              ),
            );
            final container = ProviderContainer.test();

            container.listen(provider, (a, b) {});

            expect(
              container.read(provider),
              const AsyncValue<Object?>.loading(),
            );

            expect(await container.read(provider.future!), 21);
          });
        }

        if (factory.isAutoDispose) {
          test(
              'If a provider is fully disposed, remounting it restores value from DB',
              () async {
            var value = 0;
            final provider = factory.simpleProvider(
              (ref, self) => self.valueOf,
              persistOptions: DelegatingPersist(
                read: (_) => (value,),
              ),
            );
            final container = ProviderContainer.test();

            container.read(provider);
            await container.pump();

            value = 42;

            expect(container.read(provider).valueOf, 42);
          });
        }

        test(
            'If a provider sets a value before an asynchronous adapter, it wins',
            () async {
          final completer = Completer<(int,)>();
          final provider = factory.simpleProvider(
            (ref, self) => 0,
            persistOptions: DelegatingPersist(
              read: (_) => completer.future,
            ),
          );
          final container = ProviderContainer.test();

          final sub = container.listen(provider, (a, b) {});
          completer.complete((42,));

          await container.pump();

          expect(container.read(provider).valueOf, 0);
        });
      });

      group('encode', () {
        test('When a provider emits any update, notify the DB adapter',
            () async {
          final persist = PersistMock<Object?, Object?>();
          when(persist.read(any)).thenReturn((42,));
          final encode = Encode<Object?>();
          when(encode.call(any)).thenAnswer((i) => i.positionalArguments.first);
          final provider = factory.simpleProvider(
            (ref, self) => 0,
            persistOptions: persist,
            encode: encode.call,
          );
          final container = ProviderContainer.test();

          final sub = container.listen(provider, (a, b) {});

          verifyOnly(encode, encode(0));
          verify(persist.write('key', 0)).called(1);

          container.read(provider.notifier!).state = factory.valueFor(21);

          verifyOnly(encode, encode(21));
          verify(persist.write('key', 21)).called(1);
        });

        if (factory.isAsync) {
          test('does nothing if state is set to loading', () async {
            final encode = Encode<Object?>();
            final completer = Completer<(int,)>();
            final provider = factory.simpleProvider(
              (ref, self) => 0,
              persistOptions: DelegatingPersist(
                read: (_) => (42,),
              ),
              encode: encode.call,
            );
            final container = ProviderContainer.test();

            final sub = container.listen(provider, (a, b) {});

            clearInteractions(encode);

            container.read(provider.notifier!).state =
                const AsyncLoading<int>();

            verifyZeroInteractions(encode);

            completer.complete((21,));
          });

          test('calls Persist.clear if state is set to error', () async {
            final encode = Encode<Object?>();
            final completer = Completer<(int,)>();
            final delete = Delete();
            final provider = factory.simpleProvider(
              (ref, self) => 0,
              persistOptions: DelegatingPersist(
                read: (_) => (42,),
                delete: delete.call,
              ),
              encode: encode.call,
            );
            final container = ProviderContainer.test();

            final sub = container.listen(provider, (a, b) {});

            clearInteractions(encode);

            container.read(provider.notifier!).state =
                const AsyncError<int>(42, StackTrace.empty);

            verifyZeroInteractions(encode);
            verifyOnly(delete, delete('key'));

            completer.complete((21,));
          });

          test('decode resolution does not call encode', () async {
            final encode = Encode<Object?>();
            final decodeCompleter = Completer<(int,)>();
            final resultCompleter = Completer<(int,)>();
            final provider = factory.simpleProvider(
              (ref, self) => resultCompleter.future,
              persistOptions: DelegatingPersist(
                read: (_) => decodeCompleter.future,
              ),
              encode: encode.call,
            );
            final container = ProviderContainer.test();

            final sub = container.listen(provider, (a, b) {});

            verifyZeroInteractions(encode);

            resultCompleter.complete((21,));

            verifyZeroInteractions(encode);

            decodeCompleter.complete((42,));
          });
        }
      });

      if (factory.isAsync) {
        group('AsyncValue.isFromCache', () {
          test('is "true" if the value was read from the cache', () {
            final completer = Completer<(int,)>();
            completer.complete((999,));
            final provider = factory.simpleProvider(
              (ref, self) => completer.future,
              persistOptions: DelegatingPersist(
                read: (_) => (42,),
              ),
            );
            final container = ProviderContainer.test();

            final sub = container.listen(provider, (a, b) {});

            expect(
              (container.read(provider)! as AsyncValue<Object?>).isFromCache,
              true,
            );
          });

          test('is false if manually set or returned from `create`', () {
            final provider = factory.simpleProvider(
              (ref, self) => 42,
            );
            final container = ProviderContainer.test(
              persistOptions: DelegatingPersist(read: (_) => (42,)),
            );

            final sub = container.listen(provider, (a, b) {});

            expect(
              (container.read(provider)! as AsyncValue<Object?>).isFromCache,
              false,
            );

            container.read(provider.notifier!).state = const AsyncData(21);

            expect(
              (container.read(provider)! as AsyncValue<Object?>).isFromCache,
              false,
            );
          });
        });
      }

      test('ProviderScope throws if `offline` changes on update', () {});
      group('destroyKey', () {
        test('Can specify a destroyKey on a provider', () {});

        test(
          'Initializing a provider with a destroyKey throws if the provider did not opt-in to offline',
          () {},
        );

        test('Can destroy the whole cache using a global destroyKey', () {});

        test(
          'Can destroy a provider using a provider-specific destroyKey',
          () {},
        );

        test(
          'If a provider has a destroyKey, it still respects the global one',
          () {},
        );
      });
    });
  });
}

class Encode<T> with Mock {
  Object? call(T? value);
}

class Delete with Mock {
  void call(Object? key);
}

final matrix = TestMatrix<TestFactory<Object?>>({
  ...asyncNotifierProviderFactory.values,
  ...streamNotifierProviderFactory.values,
  ...notifierProviderFactory.values,
});

extension on NotifierBase<Object?> {
  Future<Object?> get future {
    final that = this;
    switch (that) {
      case $AsyncClassModifier<Object?, Object?, Object?>():
        return that.future;
      default:
        throw AssertionError('not async');
    }
  }
}

extension on TestFactory<Object?> {
  bool get isAsync {
    return when(
      asyncNotifier: (_) => true,
      streamNotifier: (_) => true,
      notifier: (_) => false,
    );
  }

  R when<R>({
    required R Function(AsyncNotifierTestFactory) asyncNotifier,
    required R Function(StreamNotifierTestFactory) streamNotifier,
    required R Function(NotifierTestFactory) notifier,
  }) {
    if (this is AsyncNotifierTestFactory) {
      return asyncNotifier(this as AsyncNotifierTestFactory);
    }
    if (this is StreamNotifierTestFactory) {
      return streamNotifier(this as StreamNotifierTestFactory);
    }
    if (this is NotifierTestFactory) {
      return notifier(this as NotifierTestFactory);
    }
    throw AssertionError('unreachable');
  }

  ProviderBase<Object?> simpleProvider(
    FutureOr<Object?> Function(Ref, NotifierBase<Object?> notifier) create, {
    Persist? persistOptions,
    Object Function(Object? args)? persistKey,
    Object? Function(Object? encoded)? decode,
    Object? Function(Object? value)? encode,
  }) {
    decode ??= (value) => value;
    persistKey ??= (args) => 'key';
    encode ??= (value) => value;

    final e = encode;
    encode = (value) => e(value.valueOf);

    final d = decode;
    decode = (value) => d(value.valueOf);

    return when(
      asyncNotifier: (factory) {
        DeferredFamilyAsyncNotifier<Object?> familyNotifierCreate() =>
            DeferredFamilyAsyncNotifier(
              create,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
            );

        DeferredAsyncNotifier<Object?> notifierCreate() =>
            DeferredAsyncNotifier(
              create,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
            );

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose
        )) {
          case (family: false, autoDispose: false):
            return AsyncNotifierProvider<DeferredAsyncNotifier<Object?>,
                Object?>(persistOptions: persistOptions, notifierCreate);
          case (family: false, autoDispose: true):
            return AsyncNotifierProvider.autoDispose<
                DeferredAsyncNotifier<Object?>,
                Object?>(persistOptions: persistOptions, notifierCreate);
          case (family: true, autoDispose: false):
            return AsyncNotifierProvider.family<
                DeferredFamilyAsyncNotifier<Object?>, Object?, Object?>(
              persistOptions: persistOptions,
              familyNotifierCreate,
            )(0);
          case (family: true, autoDispose: true):
            return AsyncNotifierProvider.autoDispose
                .family<DeferredFamilyAsyncNotifier<Object?>, Object?, Object?>(
              persistOptions: persistOptions,
              familyNotifierCreate,
            )(0);
        }
      },
      streamNotifier: (factory) {
        Stream<Object?> handle(
          Ref ref,
          NotifierBase<AsyncValue<Object?>> self,
        ) {
          final futureOR = create(ref, self);

          final controller = StreamController<void>();
          ref.onDispose(controller.close);

          futureOR.then((value) {
            if (ref.mounted) {
              self.state = AsyncData(value);
            }
            controller.close();
          });

          return controller.stream;
        }

        DeferredFamilyStreamNotifier<Object?> familyNotifierCreate() =>
            DeferredFamilyStreamNotifier(
              handle,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
            );

        DeferredStreamNotifier<Object?> notifierCreate() =>
            DeferredStreamNotifier(
              handle,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
            );

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose
        )) {
          case (family: false, autoDispose: false):
            return StreamNotifierProvider<DeferredStreamNotifier<Object?>,
                Object?>(persistOptions: persistOptions, notifierCreate);
          case (family: false, autoDispose: true):
            return StreamNotifierProvider.autoDispose<
                DeferredStreamNotifier<Object?>,
                Object?>(persistOptions: persistOptions, notifierCreate);
          case (family: true, autoDispose: false):
            return StreamNotifierProvider.family<
                DeferredFamilyStreamNotifier<Object?>, Object?, Object?>(
              persistOptions: persistOptions,
              familyNotifierCreate,
            )(0);
          case (family: true, autoDispose: true):
            return StreamNotifierProvider.autoDispose.family<
                DeferredFamilyStreamNotifier<Object?>, Object?, Object?>(
              persistOptions: persistOptions,
              familyNotifierCreate,
            )(0);
        }
      },
      notifier: (factory) {
        DeferredFamilyNotifier<Object?> familyNotifierCreate() =>
            DeferredFamilyNotifier(
              create,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
            );

        DeferredNotifier<Object?> notifierCreate() => DeferredNotifier(
              create,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
            );

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose
        )) {
          case (family: false, autoDispose: false):
            return NotifierProvider<DeferredNotifier<Object?>, Object?>(
                persistOptions: persistOptions, notifierCreate);
          case (family: false, autoDispose: true):
            return NotifierProvider.autoDispose<DeferredNotifier<Object?>,
                Object?>(persistOptions: persistOptions, notifierCreate);
          case (family: true, autoDispose: false):
            return NotifierProvider.family<DeferredFamilyNotifier<Object?>,
                Object?, Object?>(
              persistOptions: persistOptions,
              familyNotifierCreate,
            )(0);
          case (family: true, autoDispose: true):
            return NotifierProvider.autoDispose
                .family<DeferredFamilyNotifier<Object?>, Object?, Object?>(
              persistOptions: persistOptions,
              familyNotifierCreate,
            )(0);
        }
      },
    );
  }

  Object? valueFor(Object? value) {
    return when(
      asyncNotifier: (_) => AsyncValue.data(value),
      streamNotifier: (_) => AsyncValue.data(value),
      notifier: (_) => value,
    );
  }
}

extension on Object? {
  Object? get valueOf {
    final that = this;
    switch (that) {
      case $Notifier<Object?>():
        return that.stateOrNull.valueOf;
      case NotifierBase<Object?>():
        return that.state.valueOf;
      case AsyncValue<Object?>():
        return that.value;
      default:
        return that;
    }
  }
}

class DelegatingPersist<EncodedT, DecodedT>
    extends Persist<EncodedT, DecodedT> {
  DelegatingPersist({
    required FutureOr<(DecodedT,)?> Function(Object? key) read,
    FutureOr<void> Function(Object? key, EncodedT value)? write,
    FutureOr<void> Function(Object? key)? delete,
  })  : _read = read,
        _write = write ?? ((_, __) {}),
        _delete = delete ?? ((_) => throw UnimplementedError());

  final FutureOr<(DecodedT,)?> Function(Object? key) _read;
  @override
  FutureOr<(DecodedT,)?> read(Object? key) => _read(key);

  final FutureOr<void> Function(Object? key, EncodedT value) _write;
  @override
  FutureOr<void> write(Object? key, EncodedT value) => _write(key, value);

  final FutureOr<void> Function(Object? key) _delete;
  @override
  FutureOr<void> delete(Object? key) => _delete(key);
}

// ---------- //

class DeferredAsyncNotifier<StateT> extends AsyncNotifier<StateT>
    with NotifierEncoder<StateT, Persist<Object?, StateT>>
    implements TestAsyncNotifier<StateT> {
  DeferredAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> state)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final FutureOr<StateT> Function(Ref ref, $AsyncNotifier<StateT> self) _create;
  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  FutureOr<StateT> build() => _create(ref, this);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object Function(Object? args)? _persistKey;
  @override
  Object get persistKey => switch (_persistKey) {
        null => throw UnimplementedError(),
        final cb => cb(null),
      };

  final Object? Function(AsyncValue<StateT> encoded)? _encode;
  @override
  Object? encode() {
    return switch (_encode) {
      null => throw UnimplementedError(),
      final cb => cb(state),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => throw UnimplementedError(),
      final cb => cb(serialized),
    };
  }
}

class DeferredFamilyAsyncNotifier<StateT>
    extends FamilyAsyncNotifier<StateT, int>
    with NotifierEncoder<StateT, Persist<Object?, StateT>>
    implements TestAsyncNotifier<StateT> {
  DeferredFamilyAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> state)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final FutureOr<StateT> Function(Ref ref, $AsyncNotifier<StateT> self) _create;

  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  FutureOr<StateT> build(int arg) => _create(ref, this);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object Function(Object? args)? _persistKey;
  @override
  Object get persistKey => switch (_persistKey) {
        null => throw UnimplementedError(),
        final cb => cb(arg),
      };

  final Object? Function(AsyncValue<StateT> encoded)? _encode;
  @override
  Object? encode() {
    return switch (_encode) {
      null => throw UnimplementedError(),
      final cb => cb(state),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => throw UnimplementedError(),
      final cb => cb(serialized),
    };
  }
}

class DeferredNotifier<StateT> extends Notifier<StateT>
    with NotifierEncoder<StateT, Persist<Object?, StateT>>
    implements TestNotifier<StateT> {
  DeferredNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    Object? Function(StateT encoded)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final StateT Function(Ref ref, DeferredNotifier<StateT> self) _create;
  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  Ref get ref;

  @override
  RemoveListener listenSelf(
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });

  @override
  StateT build() => _create(ref, this);

  @override
  bool updateShouldNotify(StateT previousState, StateT newState) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object Function(Object? args)? _persistKey;
  @override
  Object get persistKey => switch (_persistKey) {
        null => throw UnimplementedError(),
        final cb => cb(null),
      };

  final Object? Function(StateT encoded)? _encode;
  @override
  Object? encode() {
    return switch (_encode) {
      null => throw UnimplementedError(),
      final cb => cb(state),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => throw UnimplementedError(),
      final cb => cb(serialized),
    };
  }
}

class DeferredFamilyNotifier<StateT> extends FamilyNotifier<StateT, int>
    with NotifierEncoder<StateT, Persist<Object?, StateT>>
    implements TestNotifier<StateT> {
  DeferredFamilyNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    Object? Function(StateT value)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final StateT Function(Ref ref, DeferredFamilyNotifier<StateT> self) _create;

  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  StateT build(int arg) => _create(ref, this);

  @override
  bool updateShouldNotify(
    StateT previousState,
    StateT newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object Function(Object? args)? _persistKey;
  @override
  Object get persistKey => switch (_persistKey) {
        null => throw UnimplementedError(),
        final cb => cb(arg),
      };

  final Object? Function(StateT encoded)? _encode;
  @override
  Object? encode() {
    return switch (_encode) {
      null => throw UnimplementedError(),
      final cb => cb(state),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => throw UnimplementedError(),
      final cb => cb(serialized),
    };
  }
}

class DeferredStreamNotifier<StateT> extends StreamNotifier<StateT>
    with NotifierEncoder<StateT, Persist<Object?, StateT>>
    implements TestStreamNotifier<StateT> {
  DeferredStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(StateT value)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final Stream<StateT> Function(
    Ref ref,
    DeferredStreamNotifier<StateT> self,
  ) _create;
  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  Stream<StateT> build() => _create(ref, this);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object Function(Object? args)? _persistKey;
  @override
  Object get persistKey => switch (_persistKey) {
        null => throw UnimplementedError(),
        final cb => cb(null),
      };

  final Object? Function(StateT value)? _encode;
  @override
  Object? encode() {
    return switch (_encode) {
      null => throw UnimplementedError(),
      final cb => cb(state.requireValue),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => throw UnimplementedError(),
      final cb => cb(serialized),
    };
  }
}

class DeferredFamilyStreamNotifier<StateT>
    extends FamilyStreamNotifier<StateT, int>
    with NotifierEncoder<StateT, Persist<Object?, StateT>>
    implements TestStreamNotifier<StateT> {
  DeferredFamilyStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(StateT value)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final Stream<StateT> Function(
    Ref ref,
    DeferredFamilyStreamNotifier<StateT> self,
  ) _create;

  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  Stream<StateT> build(int arg) => _create(ref, this);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object Function(Object? args)? _persistKey;
  @override
  Object get persistKey => switch (_persistKey) {
        null => throw UnimplementedError(),
        final cb => cb(arg),
      };

  final Object? Function(StateT value)? _encode;
  @override
  Object? encode() {
    return switch (_encode) {
      null => throw UnimplementedError(),
      final cb => cb(state.requireValue),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => throw UnimplementedError(),
      final cb => cb(serialized),
    };
  }
}
