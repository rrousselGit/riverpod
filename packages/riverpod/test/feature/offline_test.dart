// ignore_for_file: prefer_final_locals

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/common/tenable.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../src/matrix.dart';
import '../src/utils.dart';
import '../third_party/fake_async.dart';

// ignore: unreachable_from_main, inference test
class EncodedT {}

// ignore: unreachable_from_main, inference test
class KeyT {}

// ignore: unreachable_from_main, inference test
class CanInferPersist extends Notifier<int> {
  @override
  int build() {
    final FutureOr<Storage<KeyT, EncodedT>> storage = Future.error(Exception());

    persist(
      storage,
      key: KeyT(),
      encode: (value) {
        int v = value;
        return EncodedT();
      },
      decode: (encoded) {
        EncodedT e = encoded;
        return 42;
      },
    );

    return 0;
  }
}

void main() {
  group('Offline', () {
    test(
      'Chaining providers using offline does not cause unnecessary rebuilds',
      () async {
        var buildCount = 0;
        // Regression test for https://github.com/rrousselGit/riverpod/issues/4116
        final container = ProviderContainer.test();
        final parent = AsyncNotifierProvider<DeferredAsyncNotifier<int>, int>(
          () => DeferredAsyncNotifier((ref, self) {
            self.persist(
              DelegatingStorage(read: (_) => const PersistedData(42)),
              key: 'key',
              encode: (value) => value,
              decode: (encoded) => encoded,
            );
            return Future.value(0);
          }),
        );
        final child = AsyncNotifierProvider<DeferredAsyncNotifier<int>, int>(
          () => DeferredAsyncNotifier((ref, self) async {
            buildCount++;
            final value = await ref.watch(parent.future);
            self.persist(
              DelegatingStorage(read: (_) => const PersistedData(21)),
              key: 'key2',
              encode: (value) => value,
              decode: (encoded) => encoded,
            );
            return value * 2;
          }),
        );

        final sub = container.listen(child.future, (a, b) {});

        expect(await sub.read(), 0);
        expect(buildCount, 1);
      },
    );

    matrix.createGroup((factory) {
      test('Persist if the notifier implements NotifierEncoder', () {
        final storage = StorageMock<String, Object?>();
        verify(storage.deleteOutOfDate());
        const op = StorageOptions(destroyKey: 'b');
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

      test('Calls delete if the destroyKey returned by Persist.read '
          'is different from the option one', () {
        final storage = StorageMock<String, Object?>();
        final container = ProviderContainer.test();
        when(
          storage.read(any),
        ).thenReturn(const PersistedData(42, destroyKey: 'a'));

        final provider = factory.simpleProvider(
          (ref, self) => self.stateOrNull.valueOf,
          persistOptions: const StorageOptions(destroyKey: 'b'),
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
            persistOptions: const StorageOptions(
              cacheTime: StorageCacheTime.unsafe_forever,
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
          when(
            storage.read(any),
          ).thenReturn(PersistedData(42, expireAt: DateTime.now()));

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
        final errors = <Object>[];
        final container = runZonedGuarded(
          ProviderContainer.test,
          (err, stack) => errors.add(err),
        )!;
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
        container.read(b);

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

      test('Reports decoding/encoding errors to the zone', () async {
        final provider = factory.simpleProvider(
          (ref, self) => 0,
          storage: DelegatingStorage(
            read: (_) => throw StateError('read'),
            write: (_, __, ___) => throw StateError('write'),
            delete: (_) => throw StateError('delete'),
          ),
        );
        final errors = <Object>[];
        final container = runZonedGuarded(
          ProviderContainer.test,
          (err, stack) => errors.add(err),
        )!;

        container.read(provider);

        await null;

        expect(errors, [
          isStateError.having((e) => e.message, 'message', 'read'),
          isStateError.having((e) => e.message, 'message', 'write'),
        ]);
        errors.clear();

        if (factory.isAsync) {
          container.read(provider.notifier!).state = const AsyncError<Object?>(
            42,
            StackTrace.empty,
          );

          await null;

          expect(
            errors.single,
            isStateError.having((e) => e.message, 'message', 'delete'),
          );
        }
      });

      test('Providers can specify their adapter', () async {
        final provider = factory.simpleProvider(
          (ref, self) => self.state.valueOf,
          storage: DelegatingStorage(read: (_) => const PersistedData(42)),
        );
        final container = ProviderContainer.test();

        final sub = container.listen(provider, (a, b) {});

        expect(container.read(provider).valueOf, 42);
      });

      test('Adapters support synchronously emitting values from the DB', () {
        Object? value;
        final provider = factory.simpleProvider(
          (ref, self) => value = self.valueOf,
          storage: DelegatingStorage(read: (_) => const PersistedData(21)),
        );
        final container = ProviderContainer.test();

        container.listen(provider, (a, b) {});

        expect(value, 21);
      });

      group('decode', () {
        test(
          'Rebuilding a provider does not re-initialize the value from DB',
          () async {
            var value = 42;
            final provider = factory.simpleProvider(
              (ref, self) => self.valueOf,
              storage: DelegatingStorage(read: (_) => PersistedData(value)),
            );
            final container = ProviderContainer.test();

            final sub = container.listen(provider, (a, b) {});

            value = 21;
            container.refresh(provider);

            expect(container.read(provider).valueOf, 42);
          },
        );

        if (factory.isAsync) {
          test(
            'Emitting an error after decoding preserves decoded state',
            () async {
              final container = ProviderContainer.test();
              final provider = factory.simpleProvider(
                (ref, self) => throw Exception('error'),
                storage: DelegatingStorage(
                  read: (_) => const PersistedData(42),
                ),
              );

              container.listen(provider, (a, b) {});

              expect(
                container.read(provider),
                isA<AsyncLoading<Object?>>()
                    .having((e) => e.isFromCache, 'isFromCache', true)
                    .having((e) => e.value, 'value', 42)
                    .having((e) => e.stackTrace, 'stackTrace', isNotNull)
                    .having((e) => e.error, 'message', isException),
              );
            },
          );

          test('Decoded value is available as AsyncLoading', () async {
            // For the sake of not having provider.future resolve with decoded value,
            // we emit decoded state as AsyncLoading.

            final container = ProviderContainer.test();
            final didPersist = Completer<void>();
            final provider = factory.simpleProvider(autoPersist: false, (
              ref,
              self,
            ) async {
              await self
                  .persist(
                    DelegatingStorage(read: (_) => const PersistedData(42)),
                    key: 'foo',
                    encode: (value) => value,
                    decode: (value) => value,
                  )
                  .future;
              didPersist.complete();
              return self.future;
            });

            final sub = container.listen(provider, (a, b) {});
            final notifier = container.read(provider.notifier!);

            await didPersist.future;

            expect(
              notifier.stateOrNull,
              isA<AsyncLoading<Object?>>()
                  .having((e) => e.isFromCache, 'isFromCache', true)
                  .having((e) => e.value, 'value', 42),
            );

            // Make it safe to dispose the provider by emitting at least one value.
            notifier.state = const AsyncData(21);
          });
        }

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
            },
          );

          test(
            'Adapters support asynchronously emitting values from the DB',
            () async {
              final didPersistCompleter = Completer<void>();
              final result = Completer<int>();
              final provider = factory.simpleProvider(autoPersist: false, (
                ref,
                self,
              ) async {
                await self
                    .persist(
                      DelegatingStorage(
                        read: (_) => Future(() => const PersistedData(21)),
                      ),
                      key: 'key',
                      encode: (value) => value,
                      decode: (encoded) => encoded,
                    )
                    .future;
                didPersistCompleter.complete();
                return result.future;
              });
              final container = ProviderContainer.test();

              container.listen(provider, (a, b) {});
              final notifier = container.read(provider.notifier!);

              expect(
                container.read(provider),
                const AsyncValue<Object?>.loading(),
              );

              await didPersistCompleter.future;

              expect(notifier.valueOf, 21);

              result.complete(42);
            },
          );
        }

        if (factory.isAutoDispose) {
          test(
            'If a provider is fully disposed, remounting it restores value from DB',
            () async {
              var value = 0;
              final provider = factory.simpleProvider(
                (ref, self) => self.valueOf,
                storage: DelegatingStorage(read: (_) => PersistedData(value)),
              );
              final container = ProviderContainer.test();

              container.read(provider);
              await container.pump();

              value = 42;

              expect(container.read(provider).valueOf, 42);
            },
          );
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
          },
        );
      });

      group('encode', () {
        test(
          'When a provider emits any update, notify the DB adapter',
          () async {
            final storage = StorageMock<String, Object?>();
            when(storage.read(any)).thenReturn(const PersistedData(42));
            final encode = Encode<Object?>();
            const op = StorageOptions(destroyKey: 'a');
            when(
              encode.call(any),
            ).thenAnswer((i) => i.positionalArguments.first);
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
          },
        );

        if (factory.isAsync) {
          test('does nothing if state is set to loading', () async {
            final encode = Encode<Object?>();
            final completer = Completer<(int,)>();
            final provider = factory.simpleProvider(
              (ref, self) => 0,
              storage: DelegatingStorage(read: (_) => const PersistedData(42)),
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

            container.read(provider.notifier!).state = const AsyncError<int>(
              42,
              StackTrace.empty,
            );

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
              storage: DelegatingStorage(read: (_) => decodeCompleter.future),
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
              storage: DelegatingStorage(read: (_) => const PersistedData(42)),
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

      persist.write('key', 'value', const StorageOptions());

      expect(
        persist.read('key'),
        isA<PersistedData<String>>().having((e) => e.data, 'data', 'value'),
      );
    });

    test('returns null after a delete', () {
      final persist = Storage<String, String>.inMemory();

      persist.write('key', 'value', const StorageOptions());
      persist.delete('key');

      expect(persist.read('key'), null);
    });
  });
}

class Encode<DecodedT> with Mock {
  Object? call(DecodedT? value);
}

// ignore: avoid_types_as_parameter_names
class Delete<KeyT> with Mock {
  void call(KeyT? key);
}

final matrix = TestMatrix<TestFactory<Object?>>({
  ...asyncNotifierProviderFactory.values,
  ...streamNotifierProviderFactory.values,
  ...notifierProviderFactory.values,
});

extension on AnyNotifier<Object?, Object?> {
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
      case $AsyncClassModifier<Object?, Object?>():
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

  ResultT when<ResultT>({
    required ResultT Function(AsyncNotifierTestFactory) asyncNotifier,
    required ResultT Function(StreamNotifierTestFactory) streamNotifier,
    required ResultT Function(NotifierTestFactory) notifier,
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
    FutureOr<Object?> Function(Ref, AnyNotifier<Object?, Object?> notifier)
    createCb, {
    Storage? storage,
    Object Function(Object? args)? persistKey,
    Object? Function(Object? encoded)? decode,
    Object? Function(Object? value)? encode,
    StorageOptions persistOptions = const StorageOptions(),
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
      AnyNotifier<Object?, Object?> self, {
      Object? Function()? args,
    }) {
      if (autoPersist) {
        self.persist(
          storage!,
          key: persistKey!(args?.call()),
          encode: encode!,
          decode: decode!,
          options: persistOptions,
        );
      }
      return createCb(ref, self);
    }

    FutureOr<Object?> familyCreate(
      Ref ref,
      AnyNotifier<Object?, Object?> self,
    ) {
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
        DeferredAsyncNotifier<Object?> familyNotifierCreate([Object? arg]) =>
            DeferredAsyncNotifier(familyCreate, arg: arg);
        DeferredAsyncNotifier<Object?> notifierCreate() =>
            DeferredAsyncNotifier(create);

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose,
        )) {
          case (family: false, autoDispose: false):
            return AsyncNotifierProvider<
              DeferredAsyncNotifier<Object?>,
              Object?
            >(notifierCreate);
          case (family: false, autoDispose: true):
            return AsyncNotifierProvider.autoDispose<
              DeferredAsyncNotifier<Object?>,
              Object?
            >(notifierCreate);
          case (family: true, autoDispose: false):
            return AsyncNotifierProvider.family<
              DeferredAsyncNotifier<Object?>,
              Object?,
              Object?
            >(familyNotifierCreate)(0);
          case (family: true, autoDispose: true):
            return AsyncNotifierProvider.autoDispose
                .family<DeferredAsyncNotifier<Object?>, Object?, Object?>(
                  familyNotifierCreate,
                )(0);
        }
      },
      streamNotifier: (factory) {
        Stream<Object?> handle(Ref ref, AnyNotifier<Object?, Object?> self) {
          final futureOR = factory.isFamily
              ? familyCreate(ref, self)
              : create(ref, self);

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

        DeferredStreamNotifier<Object?> familyNotifierCreate(Object? arg) =>
            DeferredStreamNotifier(handle, arg: arg);
        DeferredStreamNotifier<Object?> notifierCreate() =>
            DeferredStreamNotifier(handle);

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose,
        )) {
          case (family: false, autoDispose: false):
            return StreamNotifierProvider<
              DeferredStreamNotifier<Object?>,
              Object?
            >(notifierCreate);
          case (family: false, autoDispose: true):
            return StreamNotifierProvider.autoDispose<
              DeferredStreamNotifier<Object?>,
              Object?
            >(notifierCreate);
          case (family: true, autoDispose: false):
            return StreamNotifierProvider.family<
              DeferredStreamNotifier<Object?>,
              Object?,
              Object?
            >(familyNotifierCreate)(0);
          case (family: true, autoDispose: true):
            return StreamNotifierProvider.autoDispose
                .family<DeferredStreamNotifier<Object?>, Object?, Object?>(
                  familyNotifierCreate,
                )(0);
        }
      },
      notifier: (factory) {
        DeferredNotifier<Object?> familyNotifierCreate([Object? arg]) =>
            DeferredNotifier(familyCreate);
        DeferredNotifier<Object?> notifierCreate() => DeferredNotifier(create);

        switch ((
          family: factory.isFamily,
          autoDispose: factory.isAutoDispose,
        )) {
          case (family: false, autoDispose: false):
            return NotifierProvider<DeferredNotifier<Object?>, Object?>(
              notifierCreate,
            );
          case (family: false, autoDispose: true):
            return NotifierProvider.autoDispose<
              DeferredNotifier<Object?>,
              Object?
            >(notifierCreate);
          case (family: true, autoDispose: false):
            return NotifierProvider.family<
              DeferredNotifier<Object?>,
              Object?,
              Object?
            >(familyNotifierCreate)(0);
          case (family: true, autoDispose: true):
            return NotifierProvider.autoDispose
                .family<DeferredNotifier<Object?>, Object?, Object?>(
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
      case AnyNotifier<Object?, Object?>():
        return that.state.valueOf;
      case AsyncValue<Object?>():
        return that.value;
      default:
        return that;
    }
  }
}

// ignore: avoid_types_as_parameter_names
final class DelegatingStorage<KeyT, EncodedT> extends Storage<KeyT, EncodedT> {
  DelegatingStorage({
    required FutureOr<PersistedData<EncodedT>?> Function(KeyT key) read,
    FutureOr<void> Function(KeyT key, EncodedT value, StorageOptions options)?
    write,
    FutureOr<void> Function(KeyT key)? delete,
  }) : _read = read,
       _write = write ?? ((_, __, ___) {}),
       _delete = delete ?? ((_) {});

  final FutureOr<PersistedData<EncodedT>?> Function(KeyT key) _read;
  @override
  FutureOr<PersistedData<EncodedT>?> read(KeyT key) => _read(key);

  final FutureOr<void> Function(
    KeyT key,
    EncodedT value,
    StorageOptions options,
  )
  _write;
  @override
  FutureOr<void> write(KeyT key, EncodedT value, StorageOptions options) =>
      _write(key, value, options);

  final FutureOr<void> Function(KeyT key) _delete;
  @override
  FutureOr<void> delete(KeyT key) => _delete(key);

  @override
  void deleteOutOfDate() {}
}
