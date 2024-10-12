import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/providers/notifier.dart';
import 'package:test/test.dart';

import '../src/matrix.dart';

final matrix = TestMatrix<TestFactory<Object?>>({
  ...asyncNotifierProviderFactory.values,
  ...streamNotifierProviderFactory.values,
  ...notifierProviderFactory.values,
});

extension on TestFactory<Object?> {
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
    Object? Function($Notifier<Object?> notifier) create, {
    bool? shouldPersist,
    Persist? persistOptions,
    Object? Function(Object? args)? persistKey,
    Object? Function(Object? encoded)? decode,
    Object? Function(Object? value)? encode,
  }) {
    return when(
      asyncNotifier: (factory) => factory.simpleTestProvider(
        shouldPersist: shouldPersist,
        persistOptions: persistOptions,
        persistKey: persistKey,
        decode: decode == null
            ? null
            : (encoded) => decode(encoded)! as AsyncValue<Object?>,
        encode: encode,
        (ref) => create(),
      ),
      streamNotifier: (factory) {
        return factory.simpleTestProvider<Object?>(
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          persistKey: persistKey,
          decode: decode == null
              ? null
              : (encoded) => decode(encoded)! as AsyncValue<Object?>,
          encode: encode,
          (ref, notifier) {
            notifier.state = AsyncData(create());
            return const Stream<void>.empty();
          },
        );
      },
      notifier: (factory) => factory.simpleTestProvider(
        shouldPersist: shouldPersist,
        persistOptions: persistOptions,
        persistKey: persistKey,
        decode: decode,
        encode: encode,
        (ref) => create(),
      ),
    );
  }
}

extension on Object {
  Object? get valueOf {
    if (this is AsyncValue) {
      return (this as AsyncValue).requireValue;
    }
    return this;
  }
}

class DelegatingPersist extends Persist {
  DelegatingPersist({FutureOr<(Object?,)?> Function(Object? key)? read})
      : _read = read;

  final FutureOr<(Object?,)?> Function(Object? key)? _read;

  @override
  FutureOr<(Object?,)?> read(Object? key) => _read!(key);
}

void main() {
  group('Offline', () {
    matrix.createGroup((factory) {
      test('Can destroy the whole cache using a global destroyKey', () {});

      test(
        'Can destroy a provider using a provider-specific destroyKey',
        () {},
      );

      test(
        'If a provider has a destroyKey, it still respects the global one',
        () {},
      );

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
      test('shouldPersist defaults to false if persistOptions is missing',
          () {});

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
          42,
          persistOptions: DelegatingPersist(
            read: (_) => (21,),
          ),
          persistKey: (args) => 'key',
          decode: (value) => value! as int,
        );
        final container = ProviderContainer.test();

        container.listen(provider, (a, b) {});
      });

      test(
        'After destroying the state of a keepAlive provider, next read reads from cache',
        () {},
      );

      test(
        'Adapters support asynchronously emitting values from the DB',
        () {},
      );

      test(
        'If a provider sets a value before an asynchronous adapter, it wins',
        () {},
      );

      test('Can specify a destroyKey on a provider', () {});

      test(
        'Initializing a provider with a destroyKey throws if the provider did not opt-in to offline',
        () {},
      );

      test(
        'AsyncValue has a field to know if the value is from the DB or not',
        () {},
      );

      test('Notifiers have a way to await the DB reads', () {});
      test('Notifiers have a way to await the DB writes', () {});

      test('When a provider emits an update, notify the DB adapter', () {});

      test(
        'When creating a $ProviderContainer, notify the DB adapter of the list of opted-in providers',
        () {},
      );

      test(
        'Rebuilding a provider does not re-initialize the value from DB',
        () {},
      );

      test(
        'If a provider is fully disposed, remounting it restores value from DB',
        () {},
      );

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
