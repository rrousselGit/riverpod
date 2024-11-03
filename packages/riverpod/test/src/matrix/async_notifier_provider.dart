part of '../matrix.dart';

final asyncNotifierProviderFactory = TestMatrix<AsyncNotifierTestFactory>(
  {
    'AsyncNotifierProvider': AsyncNotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
      deferredNotifier: DeferredAsyncNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        retry,
        shouldPersist,
        persistOptions,
        persistKey,
        encode,
        decode,
      }) {
        return AsyncNotifierProvider<DeferredAsyncNotifier<StateT>, StateT>(
          retry: retry,
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredAsyncNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            encode: encode,
            decode: decode,
            persistKey: persistKey,
          ),
        );
      },
      provider: <StateT>(create) =>
          AsyncNotifierProvider<AsyncNotifier<StateT>, StateT>(
        () => create() as AsyncNotifier<StateT>,
      ),
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider<AsyncNotifier<Object?>, Object?>(
          () => create(null, arg) as AsyncNotifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'AsyncNotifierProvider.autoDispose': AsyncNotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
      deferredNotifier: DeferredAsyncNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        retry,
        shouldPersist,
        persistOptions,
        persistKey,
        encode,
        decode,
      }) {
        return AsyncNotifierProvider.autoDispose<DeferredAsyncNotifier<StateT>,
            StateT>(
          retry: retry,
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredAsyncNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            encode: encode,
            decode: decode,
            persistKey: persistKey,
          ),
        );
      },
      provider: <StateT>(create) {
        return AsyncNotifierProvider.autoDispose<AsyncNotifier<StateT>, StateT>(
          () => create() as AsyncNotifier<StateT>,
        );
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider.autoDispose<AsyncNotifier<Object?>,
            Object?>(
          () => create(null, arg) as AsyncNotifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'AsyncNotifierProvider.family': AsyncNotifierTestFactory(
      isAutoDispose: false,
      isFamily: true,
      deferredNotifier: DeferredFamilyAsyncNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        retry,
        shouldPersist,
        persistOptions,
        persistKey,
        encode,
        decode,
      }) {
        return AsyncNotifierProvider.family<DeferredFamilyAsyncNotifier<StateT>,
            StateT, Object?>(
          retry: retry,
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredFamilyAsyncNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            encode: encode,
            decode: decode,
            persistKey: persistKey,
          ),
        ).call(42);
      },
      provider: <StateT>(create) {
        return AsyncNotifierProvider.family<
            FamilyAsyncNotifier<StateT, Object?>, StateT, Object?>(
          () => create() as FamilyAsyncNotifier<StateT, Object?>,
        ).call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider.family<
            FamilyAsyncNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyAsyncNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
    ),
    'AsyncNotifierProvider.autoDispose.family': AsyncNotifierTestFactory(
      isAutoDispose: true,
      isFamily: true,
      deferredNotifier: DeferredFamilyAsyncNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        retry,
        shouldPersist,
        persistOptions,
        persistKey,
        encode,
        decode,
      }) {
        return AsyncNotifierProvider.family
            .autoDispose<DeferredFamilyAsyncNotifier<StateT>, StateT, Object?>(
              retry: retry,
              shouldPersist: shouldPersist,
              persistOptions: persistOptions,
              () => DeferredFamilyAsyncNotifier(
                create,
                updateShouldNotify: updateShouldNotify,
                encode: encode,
                decode: decode,
                persistKey: persistKey,
              ),
            )
            .call(42);
      },
      provider: <StateT>(create) {
        return AsyncNotifierProvider.autoDispose
            .family<FamilyAsyncNotifier<StateT, Object?>, StateT, Object?>(
              () => create() as FamilyAsyncNotifier<StateT, Object?>,
            )
            .call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider.autoDispose
            .family<FamilyAsyncNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyAsyncNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
    ),
  },
);

abstract class TestAsyncNotifier<StateT> implements $AsyncNotifier<StateT> {
  // Removing protected
  @override
  AsyncValue<StateT> get state;

  @override
  set state(AsyncValue<StateT> value);
}

class DeferredAsyncNotifier<StateT> extends AsyncNotifier<StateT>
    implements TestAsyncNotifier<StateT> {
  DeferredAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> encoded)? encode,
    AsyncValue<StateT> Function(Object? serialized)? decode,
    Object? Function(Object? args)? persistKey,
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

  final Object? Function(Object? args)? _persistKey;
  @override
  Object? get persistKey => switch (_persistKey) {
        null => super.persistKey,
        final cb => cb(null),
      };

  final Object? Function(AsyncValue<StateT> encoded)? _encode;
  @override
  Object? encode(AsyncValue<StateT> value) {
    return switch (_encode) {
      null => super.encode(value),
      final cb => cb(value),
    };
  }

  final AsyncValue<StateT> Function(Object? serialized)? _decode;
  @override
  AsyncValue<StateT> decode(Object? serialized) {
    return switch (_decode) {
      null => super.decode(serialized),
      final cb => cb(serialized),
    };
  }
}

class DeferredFamilyAsyncNotifier<StateT>
    extends FamilyAsyncNotifier<StateT, int>
    implements TestAsyncNotifier<StateT> {
  DeferredFamilyAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> encoded)? encode,
    AsyncValue<StateT> Function(Object? serialized)? decode,
    Object? Function(Object? args)? persistKey,
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

  final Object? Function(Object? args)? _persistKey;
  @override
  Object? get persistKey => switch (_persistKey) {
        null => super.persistKey,
        final cb => cb(arg),
      };

  final Object? Function(AsyncValue<StateT> encoded)? _encode;
  @override
  Object? encode(AsyncValue<StateT> value) {
    return switch (_encode) {
      null => super.encode(value),
      final cb => cb(value),
    };
  }

  final AsyncValue<StateT> Function(Object? serialized)? _decode;
  @override
  AsyncValue<StateT> decode(Object? serialized) {
    return switch (_decode) {
      null => super.decode(serialized),
      final cb => cb(serialized),
    };
  }
}

class AsyncNotifierTestFactory extends TestFactory<
    ProviderFactory<$AsyncNotifier<Object?>, ProviderBase<Object?>>> {
  AsyncNotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestAsyncNotifier<StateT> Function<StateT>(
    FutureOr<StateT> Function(Ref ref, $AsyncNotifier<StateT> self) create,
  ) deferredNotifier;

  final $AsyncNotifierProvider<TestAsyncNotifier<StateT>, StateT>
      Function<StateT>(
    FutureOr<StateT> Function(Ref ref, $AsyncNotifier<StateT> self) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    bool? shouldPersist,
    Persist? persistOptions,
    Object? Function(Object? args)? persistKey,
    AsyncValue<StateT> Function(Object? encoded)? decode,
    Object? Function(AsyncValue<StateT> value)? encode,
    Retry? retry,
  }) deferredProvider;

  final $AsyncNotifierProvider<$AsyncNotifier<StateT>, StateT> Function<StateT>(
    $AsyncNotifier<StateT> Function() create,
  ) provider;

  $AsyncNotifierProvider<TestAsyncNotifier<StateT>, StateT>
      simpleTestProvider<StateT>(
    FutureOr<StateT> Function(Ref ref, $AsyncNotifier<StateT> self) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    bool? shouldPersist,
    Persist? persistOptions,
    Object? Function(Object? args)? persistKey,
    AsyncValue<StateT> Function(Object? encoded)? decode,
    Object? Function(AsyncValue<StateT> value)? encode,
    Retry? retry,
  }) {
    return deferredProvider<StateT>(
      (ref, self) => create(ref, self),
      updateShouldNotify: updateShouldNotify,
      shouldPersist: shouldPersist,
      persistOptions: persistOptions,
      persistKey: persistKey,
      decode: decode,
      encode: encode,
      retry: retry,
    );
  }
}
