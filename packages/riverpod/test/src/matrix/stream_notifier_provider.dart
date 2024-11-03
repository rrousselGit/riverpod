part of '../matrix.dart';

final streamNotifierProviderFactory = TestMatrix<StreamNotifierTestFactory>(
  {
    'StreamNotifierProvider': StreamNotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
      deferredNotifier: DeferredStreamNotifier.new,
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
        return StreamNotifierProvider<DeferredStreamNotifier<StateT>, StateT>(
          retry: retry,
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            encode: encode,
            decode: decode,
            persistKey: persistKey,
          ),
        );
      },
      provider: <StateT>(create) =>
          StreamNotifierProvider<StreamNotifier<StateT>, StateT>(
        () => create() as StreamNotifier<StateT>,
      ),
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider<StreamNotifier<Object?>, Object?>(
          () => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'StreamNotifierProvider.autoDispose': StreamNotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
      deferredNotifier: DeferredStreamNotifier.new,
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
        return StreamNotifierProvider.autoDispose<
            DeferredStreamNotifier<StateT>, StateT>(
          retry: retry,
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            encode: encode,
            decode: decode,
            persistKey: persistKey,
          ),
        );
      },
      provider: <StateT>(create) {
        return StreamNotifierProvider.autoDispose<StreamNotifier<StateT>,
            StateT>(
          () => create() as StreamNotifier<StateT>,
        );
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider.autoDispose<StreamNotifier<Object?>,
            Object?>(
          retry: retry,
          () => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'StreamNotifierProvider.family': StreamNotifierTestFactory(
      isAutoDispose: false,
      isFamily: true,
      deferredNotifier: DeferredFamilyStreamNotifier.new,
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
        return StreamNotifierProvider.family<
            DeferredFamilyStreamNotifier<StateT>, StateT, Object?>(
          retry: retry,
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredFamilyStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            encode: encode,
            persistKey: persistKey,
            decode: decode,
          ),
        ).call(42);
      },
      provider: <StateT>(create) {
        return StreamNotifierProvider.family<
            FamilyStreamNotifier<StateT, Object?>, StateT, Object?>(
          () => create() as FamilyStreamNotifier<StateT, Object?>,
        ).call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider.family<
            FamilyStreamNotifier<Object?, Object?>, Object?, Object?>(
          retry: retry,
          () => create(null, arg) as FamilyStreamNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
    'StreamNotifierProvider.autoDispose.family': StreamNotifierTestFactory(
      isAutoDispose: true,
      isFamily: true,
      deferredNotifier: DeferredFamilyStreamNotifier.new,
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
        return StreamNotifierProvider.family
            .autoDispose<DeferredFamilyStreamNotifier<StateT>, StateT, Object?>(
              shouldPersist: shouldPersist,
              retry: retry,
              persistOptions: persistOptions,
              () => DeferredFamilyStreamNotifier(
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
        return StreamNotifierProvider.autoDispose
            .family<FamilyStreamNotifier<StateT, Object?>, StateT, Object?>(
              () => create() as FamilyStreamNotifier<StateT, Object?>,
            )
            .call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider.autoDispose
            .family<FamilyStreamNotifier<Object?, Object?>, Object?, Object?>(
          retry: retry,
          () => create(null, arg) as FamilyStreamNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
  },
);

abstract class TestStreamNotifier<StateT> implements $StreamNotifier<StateT> {
  // Removing protected
  @override
  AsyncValue<StateT> get state;

  @override
  set state(AsyncValue<StateT> value);
}

class DeferredStreamNotifier<StateT> extends StreamNotifier<StateT>
    implements TestStreamNotifier<StateT> {
  DeferredStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> encoded)? encode,
    AsyncValue<StateT> Function(Object? serialized)? decode,
    Object? Function(Object? args)? persistKey,
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

class DeferredFamilyStreamNotifier<StateT>
    extends FamilyStreamNotifier<StateT, int>
    implements TestStreamNotifier<StateT> {
  DeferredFamilyStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Object? Function(AsyncValue<StateT> encoded)? encode,
    AsyncValue<StateT> Function(Object? serialized)? decode,
    Object? Function(Object? args)? persistKey,
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

class StreamNotifierTestFactory extends TestFactory<
    ProviderFactory<$StreamNotifier<Object?>, ProviderBase<Object?>>> {
  StreamNotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestStreamNotifier<StateT> Function<StateT>(
    Stream<StateT> Function(Ref ref, $StreamNotifier<StateT> self) create,
  ) deferredNotifier;

  final $StreamNotifierProvider<TestStreamNotifier<StateT>, StateT>
      Function<StateT>(
    Stream<StateT> Function(Ref ref, $StreamNotifier<StateT> self) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
    Retry? retry,
    bool? shouldPersist,
    Persist? persistOptions,
    Object? Function(Object? args)? persistKey,
    AsyncValue<StateT> Function(Object? encoded)? decode,
    Object? Function(AsyncValue<StateT> value)? encode,
  }) deferredProvider;

  final $StreamNotifierProvider<$StreamNotifier<StateT>, StateT>
      Function<StateT>(
    $StreamNotifier<StateT> Function() create,
  ) provider;

  $StreamNotifierProvider<TestStreamNotifier<StateT>, StateT>
      simpleTestProvider<StateT>(
    Stream<StateT> Function(Ref ref, $StreamNotifier<StateT> self) create, {
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
      retry: retry,
      shouldPersist: shouldPersist,
      persistOptions: persistOptions,
      persistKey: persistKey,
      decode: decode,
      encode: encode,
    );
  }
}
