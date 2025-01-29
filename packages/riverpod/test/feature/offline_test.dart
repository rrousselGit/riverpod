import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/common/tenable.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../src/matrix.dart';
import '../src/matrix.dart' as $matrix;
import '../src/utils.dart';
import '../third_party/fake_async.dart';

void main() {
  group('Offline', () {
    test('Does not persist if the notifier does not implement NotifierEncoder',
        () {
      final provider = NotifierProvider<$matrix.DeferredNotifier<int>, int>(
        () => $matrix.DeferredNotifier<int>((ref, self) => 0),
      );
      final persist = PersistMock<String, Object?>();
      final container = ProviderContainer.test(persist: persist);

      expect(container.read(provider).valueOf, 0);

      verifyZeroInteractions(persist);
    });

    matrix.createGroup((factory) {
      test('Persist if the notifier implements NotifierEncoder', () {
        final persist = PersistMock<String, Object?>();
        const op = PersistOptions(destroyKey: 'b');
        final provider = factory.simpleProvider(
          (ref, self) => 0,
          persist: persist,
          persistOptions: op,
        );
        final container = ProviderContainer.test();

        container.read(provider);

        verify(persist.read('key')).called(1);
        verify(persist.write('key', 0, op)).called(1);

        verifyNoMoreInteractions(persist);
      });

      test(
          'Calls delete if the destroyKey returned by Persist.read '
          'is different from the option one', () {
        final persist = PersistMock<String, Object?>();
        final container = ProviderContainer.test(persist: persist);
        when(persist.read(any)).thenReturn(
          const PersistedData(42, destroyKey: 'a'),
        );

        final provider = factory.simpleProvider(
          (ref, self) => self.stateOrNull.valueOf,
          persistOptions: const PersistOptions(destroyKey: 'b'),
        );

        expect(container.read(provider).valueOf, null);

        verify(persist.delete('key')).called(1);
      });

      test('handles "forever" cacheTime', () {
        return fakeAsync((async) {
          final persist = Persist.inMemory();
          final container = ProviderContainer.test(persist: persist);
          final container2 = ProviderContainer.test(persist: persist);

          var value = 42;
          final provider = factory.simpleProvider(
            (ref, self) => self.stateOrNull.valueOf ?? value,
            persistOptions: const PersistOptions(
              cacheTime: PersistCacheTime.unsafe_forever,
            ),
          );

          expect(container.read(provider).valueOf, 42);

          async.elapse(const Duration(days: 365 * 10));

          value = 21;
          expect(container2.read(provider).valueOf, 42);
        });
      });

      test('Calls delete if expireAt has expired', () {
        return fakeAsync((async) {
          final persist = PersistMock<String, Object?>();
          final container = ProviderContainer.test(persist: persist);
          when(persist.read(any)).thenReturn(
            PersistedData(42, expireAt: DateTime.now()),
          );

          async.elapse(const Duration(seconds: 5));

          final provider = factory.simpleProvider(
            (ref, self) => self.stateOrNull.valueOf,
          );

          expect(container.read(provider).valueOf, null);

          verify(persist.delete('key')).called(1);
        });
      });

      test('throws if two providers have the same persistKey', () {
        final container = ProviderContainer.test(
          persist: DelegatingPersist(read: (_) => const PersistedData(42)),
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
          persist: DelegatingPersist(
            read: (_) => throw StateError('read'),
            write: (_, __, ___) => throw StateError('write'),
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
          persist: DelegatingPersist(
            read: (_) => const PersistedData(42),
          ),
        );

        final sub = container.listen(provider, (a, b) {});

        expect(container.read(provider).valueOf, 42);
      });

      test('Providers can specify their adapter', () async {
        final provider = factory.simpleProvider(
          (ref, self) => self.state.valueOf,
          persist: DelegatingPersist(
            read: (_) => const PersistedData(42),
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
          persist: DelegatingPersist(
            read: (_) => const PersistedData(21),
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
            persist: DelegatingPersist(
              read: (_) => PersistedData(
                value,
              ),
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
              persist: DelegatingPersist(
                read: (_) => PersistedData(completer.future),
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
              persist: DelegatingPersist(
                read: (_) => Future(() => const PersistedData(21)),
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
              persist: DelegatingPersist(
                read: (_) => PersistedData(value),
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
            persist: DelegatingPersist(
              read: (_) => PersistedData(completer.future),
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
          final persist = PersistMock<String, Object?>();
          when(persist.read(any)).thenReturn(const PersistedData(42));
          final encode = Encode<Object?>();
          const op = PersistOptions(destroyKey: 'a');
          when(encode.call(any)).thenAnswer((i) => i.positionalArguments.first);
          final provider = factory.simpleProvider(
            (ref, self) => 0,
            persist: persist,
            persistOptions: op,
            encode: encode.call,
          );
          final container = ProviderContainer.test();

          final sub = container.listen(provider, (a, b) {});

          verifyOnly(encode, encode(0));
          verify(persist.write('key', 0, op)).called(1);

          container.read(provider.notifier!).state = factory.valueFor(21);

          verifyOnly(encode, encode(21));
          verify(persist.write('key', 21, op)).called(1);
        });

        if (factory.isAsync) {
          test('does nothing if state is set to loading', () async {
            final encode = Encode<Object?>();
            final completer = Completer<(int,)>();
            final provider = factory.simpleProvider(
              (ref, self) => 0,
              persist: DelegatingPersist(
                read: (_) => const PersistedData(42),
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
            final delete = Delete<Object?>();
            final provider = factory.simpleProvider(
              (ref, self) => 0,
              persist: DelegatingPersist(
                read: (_) => const PersistedData(42),
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
            final decodeCompleter = Completer<PersistedData<int>>();
            final resultCompleter = Completer<PersistedData<int>>();
            final provider = factory.simpleProvider(
              (ref, self) => resultCompleter.future,
              persist: DelegatingPersist(
                read: (_) => decodeCompleter.future,
              ),
              encode: encode.call,
            );
            final container = ProviderContainer.test();

            final sub = container.listen(provider, (a, b) {});

            verifyZeroInteractions(encode);

            resultCompleter.complete(const PersistedData(21));

            verifyZeroInteractions(encode);

            decodeCompleter.complete(const PersistedData(42));
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
              persist: DelegatingPersist(
                read: (_) => const PersistedData(42),
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
              persist: DelegatingPersist(read: (_) => const PersistedData(42)),
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
    });
  });

  group('InMemoryPersist', () {
    test('returns null on unknown keys', () {
      final persist = Persist<String, String>.inMemory();

      expect(persist.read('unknown'), null);
    });

    test('returns the value if it exists', () {
      final persist = Persist<String, String>.inMemory();

      persist.write('key', 'value', const PersistOptions());

      expect(
        persist.read('key'),
        isA<PersistedData<String>>().having((e) => e.data, 'data', 'value'),
      );
    });

    test('returns null after a delete', () {
      final persist = Persist<String, String>.inMemory();

      persist.write('key', 'value', const PersistOptions());
      persist.delete('key');

      expect(persist.read('key'), null);
    });
  });
}

class Encode<T> with Mock {
  Object? call(T? value);
}

class Delete<KeyT> with Mock {
  void call(KeyT? key);
}

final matrix = TestMatrix<TestFactory<Object?>>({
  ...asyncNotifierProviderFactory.values,
  ...streamNotifierProviderFactory.values,
  ...notifierProviderFactory.values,
});

extension on NotifierBase<Object?> {
  Object? get stateOrNull {
    final that = this;
    switch (that) {
      case $Notifier<Object?>():
        return that.stateOrNull;
      default:
        return that.state;
    }
  }

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
    Persist? persist,
    Object Function(Object? args)? persistKey,
    Object? Function(Object? encoded)? decode,
    Object? Function(Object? value)? encode,
    PersistOptions persistOptions = const PersistOptions(),
  }) {
    decode ??= (value) => value;
    persistKey ??= (args) => 'key';
    encode ??= (value) => value;

    final e = encode;
    // ignore: parameter_assignments
    encode = (value) => e(value.valueOf);

    final d = decode;
    // ignore: parameter_assignments
    decode = (value) => d(value.valueOf);

    return when(
      asyncNotifier: (factory) {
        DeferredFamilyAsyncNotifier<Object?> familyNotifierCreate() =>
            DeferredFamilyAsyncNotifier(
              create,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
              persist: persist,
              persistOptions: persistOptions,
            );

        DeferredAsyncNotifier<Object?> notifierCreate() =>
            DeferredAsyncNotifier(
              create,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
              persist: persist,
              persistOptions: persistOptions,
            );

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose
        )) {
          case (family: false, autoDispose: false):
            return AsyncNotifierProvider<DeferredAsyncNotifier<Object?>,
                Object?>(notifierCreate);
          case (family: false, autoDispose: true):
            return AsyncNotifierProvider.autoDispose<
                DeferredAsyncNotifier<Object?>, Object?>(notifierCreate);
          case (family: true, autoDispose: false):
            return AsyncNotifierProvider.family<
                DeferredFamilyAsyncNotifier<Object?>, Object?, Object?>(
              familyNotifierCreate,
            )(0);
          case (family: true, autoDispose: true):
            return AsyncNotifierProvider.autoDispose
                .family<DeferredFamilyAsyncNotifier<Object?>, Object?, Object?>(
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
              persist: persist,
              persistOptions: persistOptions,
            );

        DeferredStreamNotifier<Object?> notifierCreate() =>
            DeferredStreamNotifier(
              handle,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
              persist: persist,
              persistOptions: persistOptions,
            );

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose
        )) {
          case (family: false, autoDispose: false):
            return StreamNotifierProvider<DeferredStreamNotifier<Object?>,
                Object?>(notifierCreate);
          case (family: false, autoDispose: true):
            return StreamNotifierProvider.autoDispose<
                DeferredStreamNotifier<Object?>, Object?>(notifierCreate);
          case (family: true, autoDispose: false):
            return StreamNotifierProvider.family<
                DeferredFamilyStreamNotifier<Object?>, Object?, Object?>(
              familyNotifierCreate,
            )(0);
          case (family: true, autoDispose: true):
            return StreamNotifierProvider.autoDispose.family<
                DeferredFamilyStreamNotifier<Object?>, Object?, Object?>(
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
              persist: persist,
              persistOptions: persistOptions,
            );

        DeferredNotifier<Object?> notifierCreate() => DeferredNotifier(
              create,
              persistKey: persistKey,
              decode: decode,
              encode: encode,
              persist: persist,
              persistOptions: persistOptions,
            );

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose
        )) {
          case (family: false, autoDispose: false):
            return NotifierProvider<DeferredNotifier<Object?>, Object?>(
              notifierCreate,
            );
          case (family: false, autoDispose: true):
            return NotifierProvider.autoDispose<DeferredNotifier<Object?>,
                Object?>(notifierCreate);
          case (family: true, autoDispose: false):
            return NotifierProvider.family<DeferredFamilyNotifier<Object?>,
                Object?, Object?>(
              familyNotifierCreate,
            )(0);
          case (family: true, autoDispose: true):
            return NotifierProvider.autoDispose
                .family<DeferredFamilyNotifier<Object?>, Object?, Object?>(
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

class DelegatingPersist<KeyT, EncodedT> implements Persist<KeyT, EncodedT> {
  DelegatingPersist({
    required FutureOr<PersistedData<EncodedT>?> Function(KeyT key) read,
    FutureOr<void> Function(
      KeyT key,
      EncodedT value,
      PersistOptions options,
    )? write,
    FutureOr<void> Function(KeyT key)? delete,
  })  : _read = read,
        _write = write ?? ((_, __, ___) {}),
        _delete = delete ?? ((_) => throw UnimplementedError());

  final FutureOr<PersistedData<EncodedT>?> Function(KeyT key) _read;
  @override
  FutureOr<PersistedData<EncodedT>?> read(KeyT key) => _read(key);

  final FutureOr<void> Function(
    KeyT key,
    EncodedT value,
    PersistOptions options,
  ) _write;
  @override
  FutureOr<void> write(KeyT key, EncodedT value, PersistOptions options) =>
      _write(key, value, options);

  final FutureOr<void> Function(KeyT key) _delete;
  @override
  FutureOr<void> delete(KeyT key) => _delete(key);
}

// ---------- //

class DeferredAsyncNotifier<StateT> extends AsyncNotifier<StateT>
    with NotifierEncoder<Object?, StateT, Object?>
    implements TestAsyncNotifier<StateT> {
  DeferredAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> state)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
    Persist<Object?, Object?>? persist,
    this.persistOptions = const PersistOptions(),
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persist = persist,
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

  final Persist<Object?, Object?>? _persist;
  @override
  Persist<Object?, Object?> get persist => _persist ?? super.persist;

  @override
  final PersistOptions persistOptions;
}

class DeferredFamilyAsyncNotifier<StateT>
    extends FamilyAsyncNotifier<StateT, int>
    with NotifierEncoder<Object?, StateT, Object?>
    implements TestAsyncNotifier<StateT> {
  DeferredFamilyAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> state)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
    Persist<Object?, Object?>? persist,
    this.persistOptions = const PersistOptions(),
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persist = persist,
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

  final Persist<Object?, Object?>? _persist;
  @override
  Persist<Object?, Object?> get persist => _persist ?? super.persist;

  @override
  final PersistOptions persistOptions;
}

class DeferredNotifier<StateT> extends Notifier<StateT>
    with NotifierEncoder<Object?, StateT, Object?>
    implements TestNotifier<StateT> {
  DeferredNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    Object? Function(StateT encoded)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
    Persist<Object?, Object?>? persist,
    this.persistOptions = const PersistOptions(),
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persist = persist,
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

  final Persist<Object?, Object?>? _persist;
  @override
  Persist<Object?, Object?> get persist => _persist ?? super.persist;

  @override
  final PersistOptions persistOptions;
}

class DeferredFamilyNotifier<StateT> extends FamilyNotifier<StateT, int>
    with NotifierEncoder<Object?, StateT, Object?>
    implements TestNotifier<StateT> {
  DeferredFamilyNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    Object? Function(StateT value)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
    Persist<Object?, Object?>? persist,
    this.persistOptions = const PersistOptions(),
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persist = persist,
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

  final Persist<Object?, Object?>? _persist;
  @override
  Persist<Object?, Object?> get persist => _persist ?? super.persist;

  @override
  final PersistOptions persistOptions;
}

class DeferredStreamNotifier<StateT> extends StreamNotifier<StateT>
    with NotifierEncoder<Object?, StateT, Object?>
    implements TestStreamNotifier<StateT> {
  DeferredStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(StateT value)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
    Persist<Object?, Object?>? persist,
    this.persistOptions = const PersistOptions(),
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persist = persist,
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

  final Persist<Object?, Object?>? _persist;
  @override
  Persist<Object?, Object?> get persist => _persist ?? super.persist;

  @override
  final PersistOptions persistOptions;
}

class DeferredFamilyStreamNotifier<StateT>
    extends FamilyStreamNotifier<StateT, int>
    with NotifierEncoder<Object?, StateT, Object?>
    implements TestStreamNotifier<StateT> {
  DeferredFamilyStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(StateT value)? encode,
    StateT Function(Object? serialized)? decode,
    Object Function(Object? args)? persistKey,
    Persist<Object?, Object?>? persist,
    this.persistOptions = const PersistOptions(),
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persist = persist,
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

  final Persist<Object?, Object?>? _persist;
  @override
  Persist<Object?, Object?> get persist => _persist ?? super.persist;

  @override
  final PersistOptions persistOptions;
}
