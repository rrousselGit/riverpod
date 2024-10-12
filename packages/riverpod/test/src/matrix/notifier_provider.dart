part of '../matrix.dart';

final notifierProviderFactory = TestMatrix<NotifierTestFactory>(
  {
    'NotifierProvider': NotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
      deferredNotifier: DeferredNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        shouldPersist,
        persistOptions,
        persistKey,
        decode,
        encode,
      }) {
        return NotifierProvider<DeferredNotifier<StateT>, StateT>(
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            persistKey: persistKey,
            decode: decode,
            encode: encode,
          ),
        );
      },
      provider: <StateT>(create) => NotifierProvider<Notifier<StateT>, StateT>(
        () => create() as Notifier<StateT>,
      ),
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider<Notifier<Object?>, Object?>(
          () => create(null, arg) as Notifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'NotifierProvider.autoDispose': NotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
      deferredNotifier: DeferredNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        shouldPersist,
        persistOptions,
        persistKey,
        decode,
        encode,
      }) {
        return NotifierProvider.autoDispose<DeferredNotifier<StateT>, StateT>(
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            persistKey: persistKey,
            decode: decode,
            encode: encode,
          ),
        );
      },
      provider: <StateT>(create) {
        return NotifierProvider.autoDispose<Notifier<StateT>, StateT>(
          () => create() as Notifier<StateT>,
        );
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider.autoDispose<Notifier<Object?>, Object?>(
          () => create(null, arg) as Notifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'NotifierProvider.family': NotifierTestFactory(
      isAutoDispose: false,
      isFamily: true,
      deferredNotifier: DeferredFamilyNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        shouldPersist,
        persistOptions,
        persistKey,
        decode,
        encode,
      }) {
        return NotifierProvider.family<DeferredFamilyNotifier<StateT>, StateT,
            Object?>(
          shouldPersist: shouldPersist,
          persistOptions: persistOptions,
          () => DeferredFamilyNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
            persistKey: persistKey,
            decode: decode,
            encode: encode,
          ),
        ).call(42);
      },
      provider: <StateT>(create) {
        return NotifierProvider.family<FamilyNotifier<StateT, Object?>, StateT,
            Object?>(
          () => create() as FamilyNotifier<StateT, Object?>,
        ).call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider.family<FamilyNotifier<Object?, Object?>,
            Object?, Object?>(
          () => create(null, arg) as FamilyNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
    ),
    'NotifierProvider.autoDispose.family': NotifierTestFactory(
      isAutoDispose: true,
      isFamily: true,
      deferredNotifier: DeferredFamilyNotifier.new,
      deferredProvider: <StateT>(
        create, {
        updateShouldNotify,
        shouldPersist,
        persistOptions,
        persistKey,
        decode,
        encode,
      }) {
        return NotifierProvider.family
            .autoDispose<DeferredFamilyNotifier<StateT>, StateT, Object?>(
              shouldPersist: shouldPersist,
              persistOptions: persistOptions,
              () => DeferredFamilyNotifier(
                create,
                updateShouldNotify: updateShouldNotify,
                persistKey: persistKey,
                decode: decode,
                encode: encode,
              ),
            )
            .call(42);
      },
      provider: <StateT>(create) {
        return NotifierProvider.autoDispose
            .family<FamilyNotifier<StateT, Object?>, StateT, Object?>(
              () => create() as FamilyNotifier<StateT, Object?>,
            )
            .call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider.autoDispose
            .family<FamilyNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
    ),
  },
);

abstract class TestNotifier<StateT> implements $Notifier<StateT> {
  // Removing protected
  @override
  StateT get state;

  @override
  set state(StateT value);
}

class DeferredNotifier<StateT> extends Notifier<StateT>
    implements TestNotifier<StateT> {
  DeferredNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    Object? Function(StateT encoded)? encode,
    StateT Function(Object? serialized)? decode,
    Object? Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final StateT Function(Ref<StateT> ref) _create;
  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  StateT build() => _create(ref);

  @override
  bool updateShouldNotify(StateT previousState, StateT newState) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object? Function(Object? args)? _persistKey;
  @override
  Object? get persistKey => switch (_persistKey) {
        null => super.persistKey,
        final cb => cb(null),
      };

  final Object? Function(StateT encoded)? _encode;
  @override
  Object? encode(StateT value) {
    return switch (_encode) {
      null => super.encode(value),
      final cb => cb(value),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => super.decode(serialized),
      final cb => cb(serialized),
    };
  }
}

class DeferredFamilyNotifier<StateT> extends FamilyNotifier<StateT, int>
    implements TestNotifier<StateT> {
  DeferredFamilyNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    Object? Function(StateT encoded)? encode,
    StateT Function(Object? serialized)? decode,
    Object? Function(Object? args)? persistKey,
  })  : _updateShouldNotify = updateShouldNotify,
        _encode = encode,
        _decode = decode,
        _persistKey = persistKey;

  final StateT Function(Ref<StateT> ref) _create;

  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  StateT build(int arg) => _create(ref);

  @override
  bool updateShouldNotify(
    StateT previousState,
    StateT newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);

  final Object? Function(Object? args)? _persistKey;
  @override
  Object? get persistKey => switch (_persistKey) {
        null => super.persistKey,
        final cb => cb(arg),
      };

  final Object? Function(StateT encoded)? _encode;
  @override
  Object? encode(StateT value) {
    return switch (_encode) {
      null => super.encode(value),
      final cb => cb(value),
    };
  }

  final StateT Function(Object? serialized)? _decode;
  @override
  StateT decode(Object? serialized) {
    return switch (_decode) {
      null => super.decode(serialized),
      final cb => cb(serialized),
    };
  }
}

class NotifierTestFactory extends TestFactory<
    ProviderFactory<$Notifier<Object?>, ProviderBase<Object?>, void>> {
  NotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestNotifier<StateT> Function<StateT>(
    StateT Function(Ref<StateT> ref) create,
  ) deferredNotifier;

  final $NotifierProvider<TestNotifier<StateT>, StateT> Function<StateT>(
    StateT Function(Ref<StateT> ref) create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    bool? shouldPersist,
    Persist? persistOptions,
    Object? Function(Object? args)? persistKey,
    StateT Function(Object? encoded)? decode,
    Object? Function(StateT value)? encode,
  }) deferredProvider;

  final $NotifierProvider<$Notifier<StateT>, StateT> Function<StateT>(
    $Notifier<StateT> Function() create,
  ) provider;

  $NotifierProvider<TestNotifier<StateT>, StateT> simpleTestProvider<StateT>(
    StateT Function(Ref<StateT> ref) create, {
    bool Function(StateT, StateT)? updateShouldNotify,
    bool? shouldPersist,
    Persist? persistOptions,
    Object? Function(Object? args)? persistKey,
    StateT Function(Object? encoded)? decode,
    Object? Function(StateT value)? encode,
  }) {
    return deferredProvider<StateT>(
      (ref) => create(ref),
      updateShouldNotify: updateShouldNotify,
      shouldPersist: shouldPersist,
      persistOptions: persistOptions,
      persistKey: persistKey,
      decode: decode,
      encode: encode,
    );
  }
}
