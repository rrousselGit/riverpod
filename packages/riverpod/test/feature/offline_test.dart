import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/common/tenable.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../src/matrix.dart';
import '../src/utils.dart';

final matrix = TestMatrix<TestFactory<Object?>>({
  ...asyncNotifierProviderFactory.values,
  ...streamNotifierProviderFactory.values,
  ...notifierProviderFactory.values,
});

extension on NotifierBase<Object?, Object?> {
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
    FutureOr<Object?> Function(Ref, NotifierBase<Object?, Object?> notifier)
        create, {
    bool? shouldPersist,
    Persist? persistOptions,
    Object? Function(Object? args)? persistKey,
    Object? Function(Object? encoded)? decode,
    Object? Function(Object? value)? encode,
  }) {
    decode ??= (value) => value;
    persistKey ??= (args) => 'key';
    encode ??= (value) {};

    return when(
      asyncNotifier: (factory) => factory.simpleTestProvider<Object?>(
        shouldPersist: shouldPersist,
        persistOptions: persistOptions,
        persistKey: persistKey,
        decode: decode,
        encode: encode,
        (ref, self) => create(ref, self),
      ),
      streamNotifier: (factory) {
        return factory.simpleTestProvider<Object?>(
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          persistKey: persistKey,
          decode: decode,
          encode: encode,
          (ref, self) {
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
          },
        );
      },
      notifier: (factory) => factory.simpleTestProvider(
        shouldPersist: shouldPersist,
        persistOptions: persistOptions,
        persistKey: persistKey,
        decode: decode,
        encode: encode,
        (ref, self) => create(ref, self),
      ),
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
      case NotifierBase<Object?, Object?>():
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
  })  : _read = read,
        _write = write ?? ((_, __) {});

  final FutureOr<(DecodedT,)?> Function(Object? key) _read;
  @override
  FutureOr<(DecodedT,)?> read(Object? key) => _read(key);

  final FutureOr<void> Function(Object? key, EncodedT value) _write;
  @override
  FutureOr<void> write(Object? key, EncodedT value) => _write(key, value);
}

void main() {
  group('Offline', () {
    matrix.createGroup((factory) {
      test(
        'When a provider is overridden, keep using the default implementation for persistence',
        () {},
      );

      test(
        'throws if using offline but the notifier does not implement PersistAdapter',
        () {},
      );

      test(
        'throws if specifying persist on a provider with offline disabled',
        () {},
      );

      test('shouldPersist defaults to true if persistOptions is set', () {});
      test(
        'shouldPersist defaults to false if persistOptions is missing',
        () {},
      );

      test('throws if two providers have the same persistKey', () {});

      test('Can specify an adapter on $ProviderContainer', () {});

      test(
        '$ProviderContainer throws a provider opted to offline but no adapter is found',
        () {},
      );

      test('Providers can specify their adapter', () {});

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
          final encode = Encode<Object?>();
          final provider = factory.simpleProvider(
            (ref, self) => 0,
            persistOptions: DelegatingPersist(
              read: (_) => (42,),
            ),
            encode: encode.call,
          );
          final container = ProviderContainer.test();

          final sub = container.listen(provider, (a, b) {});

          verifyOnly(encode, encode(0));

          container.read(provider.notifier!).state = factory.valueFor(21);

          verifyOnly(encode, encode(21));
        });

        if (factory.isAsync) {
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

      test('ProviderScope throws if `offline` changes on update', () {});

      test(
        'ProviderScope throws if `offline` is specified but not adapter',
        () {},
      );

      test(
        "Scoped providers opted-in to offline use their container's adapter",
        () {},
      );

      test(
        'overrideWithValue does not ask adapters for initializations',
        () {},
      );

      test('overrideWith does ask adapters for initializations', () {});

      test('Give adapters the list of static members of a Model', () {});

      test('Supports Map<Model, Model2>', () {});

      test('Primitive types do not need specific encoding methods', () {});

      test('$ProviderContainer can dump the DB state', () {});

      test(
        'Families can opt-in to offline, as long as their arguments are supported by the adapter',
        () {},
      );

      test('Supports generics providers', () {});

      test(
        'Verify that unused Model static members are tree-shaken away',
        () {},
      );
      test('Verify that unused Model methods are tree-shaken away', () {});
    });
  });
}

class Encode<T> with Mock {
  Object? call(T? value);
}
