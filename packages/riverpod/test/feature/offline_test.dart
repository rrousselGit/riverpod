import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/common/tenable.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../src/matrix.dart';
import '../src/utils.dart';
import '../third_party/fake_async.dart';

void main() {
  group('Offline', () {
    matrix.createGroup((factory) {
      test('Persist if the notifier implements NotifierEncoder', () {
        final storage = StorageMock<String, Object?>();
        const op = PersistOptions(destroyKey: 'b');
        final provider = factory.simpleProvider(
          (ref, self) => 0,
          storage: storage,
          persistOptions: op,
        );
        final container = ProviderContainer.test();

        container.read(provider);

        verify(storage.read('key')).called(1);
        verify(storage.write('key', 0, op)).called(1);

        verifyNoMoreInteractions(storage);
      });

      test(
          'Calls delete if the destroyKey returned by Persist.read '
          'is different from the option one', () {
        final storage = StorageMock<String, Object?>();
        final container = ProviderContainer.test();
        when(storage.read(any)).thenReturn(
          const PersistedData(42, destroyKey: 'a'),
        );

        final provider = factory.simpleProvider(
          (ref, self) => self.stateOrNull.valueOf,
          persistOptions: const PersistOptions(destroyKey: 'b'),
          storage: storage,
        );

        expect(container.read(provider).valueOf, null);

        verify(storage.delete('key')).called(1);
      });

      test('handles "forever" cacheTime', () {
        return fakeAsync((async) {
          final storage = Storage.inMemory();
          final container = ProviderContainer.test();
          final container2 = ProviderContainer.test();

          var value = 42;
          final provider = factory.simpleProvider(
            (ref, self) => self.stateOrNull.valueOf ?? value,
            storage: storage,
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
          final storage = StorageMock<String, Object?>();
          final container = ProviderContainer.test();
          when(storage.read(any)).thenReturn(
            PersistedData(42, expireAt: DateTime.now()),
          );

          async.elapse(const Duration(seconds: 5));

          final provider = factory.simpleProvider(
            (ref, self) => self.stateOrNull.valueOf,
            storage: storage,
          );

          expect(container.read(provider).valueOf, null);

          verify(storage.delete('key')).called(1);
        });
      });

      test('throws if two providers have the same persistKey', () {
        final container = ProviderContainer.test();
        final a = factory.simpleProvider(
          (ref, self) => 0,
          persistKey: (_) => 'myKey',
          storage: DelegatingStorage(read: (_) => const PersistedData(42)),
        );
        final b = factory.simpleProvider(
          (ref, self) => 0,
          persistKey: (_) => 'myKey',
          storage: DelegatingStorage(read: (_) => const PersistedData(42)),
        );

        container.read(a);

        final errors = <Object>[];
        runZonedGuarded(
          () => container.read(b),
          (e, s) => errors.add(e),
        );

        expect(errors, hasLength(1));
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

      if (factory.isAsync) {
        test('supports async storage', () async {
          final provider = factory.simpleProvider(
            (ref, self) {
              final persistable = self as Persistable;

              persistable.persist(
                key: 'key',
                storage: Future.value(
                  DelegatingStorage(
                    read: (_) => Future.value(const PersistedData(42)),
                  ),
                ),
                encode: (value) => value,
                decode: (encoded) => encoded,
              );

              return self.future;
            },
            autoPersist: false,
          );
        });
      }

      test('Reports decoding/encoding errors to the zone', () async {
        final provider = factory.simpleProvider(
          (ref, self) => 0,
          storage: DelegatingStorage(
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

      test('Providers can specify their adapter', () async {
        final provider = factory.simpleProvider(
          (ref, self) => self.state.valueOf,
          storage: DelegatingStorage(
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
          storage: DelegatingStorage(
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
            storage: DelegatingStorage(
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
              storage: DelegatingStorage(
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
              storage: DelegatingStorage(
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
              storage: DelegatingStorage(
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
            storage: DelegatingStorage(
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
          final storage = StorageMock<String, Object?>();
          when(storage.read(any)).thenReturn(const PersistedData(42));
          final encode = Encode<Object?>();
          const op = PersistOptions(destroyKey: 'a');
          when(encode.call(any)).thenAnswer((i) => i.positionalArguments.first);
          final provider = factory.simpleProvider(
            (ref, self) => 0,
            storage: storage,
            persistOptions: op,
            encode: encode.call,
          );
          final container = ProviderContainer.test();

          final sub = container.listen(provider, (a, b) {});

          verifyOnly(encode, encode(0));
          verify(storage.write('key', 0, op)).called(1);

          container.read(provider.notifier!).state = factory.valueFor(21);

          verifyOnly(encode, encode(21));
          verify(storage.write('key', 21, op)).called(1);
        });

        if (factory.isAsync) {
          test('does nothing if state is set to loading', () async {
            final encode = Encode<Object?>();
            final completer = Completer<(int,)>();
            final provider = factory.simpleProvider(
              (ref, self) => 0,
              storage: DelegatingStorage(
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
              storage: DelegatingStorage(
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
              storage: DelegatingStorage(
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
              storage: DelegatingStorage(
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
              storage: DelegatingStorage(read: (_) => const PersistedData(42)),
            );
            final container = ProviderContainer.test();

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
      final persist = Storage<String, String>.inMemory();

      expect(persist.read('unknown'), null);
    });

    test('returns the value if it exists', () {
      final persist = Storage<String, String>.inMemory();

      persist.write('key', 'value', const PersistOptions());

      expect(
        persist.read('key'),
        isA<PersistedData<String>>().having((e) => e.data, 'data', 'value'),
      );
    });

    test('returns null after a delete', () {
      final persist = Storage<String, String>.inMemory();

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
    FutureOr<Object?> Function(Ref, NotifierBase<Object?> notifier) createCb, {
    Storage? storage,
    Object Function(Object? args)? persistKey,
    Object? Function(Object? encoded)? decode,
    Object? Function(Object? value)? encode,
    PersistOptions persistOptions = const PersistOptions(),
    bool autoPersist = true,
  }) {
    assert(
      !autoPersist || storage != null,
      'If autoPersist is true, storage must be provided',
    );
    decode ??= (value) => value;
    persistKey ??= (args) => 'key';
    encode ??= (value) => value;

    FutureOr<Object?> create(
      Ref ref,
      NotifierBase<Object?> self, {
      Object? Function()? args,
    }) {
      if (autoPersist) {
        (self as Persistable<Object?, Object?, Object?>).persist(
          storage: storage!,
          key: persistKey!(args?.call()),
          encode: encode!,
          decode: decode!,
          options: persistOptions,
        );
      }
      return createCb(ref, self);
    }

    FutureOr<Object?> familyCreate(Ref ref, NotifierBase<Object?> self) {
      return create(ref, self, args: () => (self as dynamic).arg);
    }

    final e = encode;
    // ignore: parameter_assignments
    encode = (value) => e(value.valueOf);

    final d = decode;
    // ignore: parameter_assignments
    decode = (value) => d(value.valueOf);

    return when(
      asyncNotifier: (factory) {
        DeferredFamilyAsyncNotifier<Object?> familyNotifierCreate() =>
            DeferredFamilyAsyncNotifier(familyCreate);
        DeferredAsyncNotifier<Object?> notifierCreate() =>
            DeferredAsyncNotifier(create);

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
          NotifierBase<Object?> self,
        ) {
          final futureOR =
              factory.isFamily ? familyCreate(ref, self) : create(ref, self);

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
            DeferredFamilyStreamNotifier(handle);
        DeferredStreamNotifier<Object?> notifierCreate() =>
            DeferredStreamNotifier(handle);

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
            DeferredFamilyNotifier(familyCreate);
        DeferredNotifier<Object?> notifierCreate() => DeferredNotifier(create);

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

class DelegatingStorage<KeyT, EncodedT> implements Storage<KeyT, EncodedT> {
  DelegatingStorage({
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
