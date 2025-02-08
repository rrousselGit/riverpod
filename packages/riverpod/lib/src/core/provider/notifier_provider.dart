part of '../../framework.dart';

/// An error thrown if a Notifier is associated multiple times with a provider.
@internal
const alreadyInitializedError = '''
A NotifierProvider returned a Notifier instance that is already associated
with another provider.

To fix, do not reuse the same Notifier instance multiple times.
NotifierProviders are expected to always create a new Notifier instance.
''';

/// The error message for when a notifier is used when uninitialized.
@internal
const uninitializedElementError = '''
Tried to use a notifier in an uninitialized state.
This means that you tried to either:
- Use ref/state inside the constructor of a notifier.
  In this case you should move your logic inside the "build" method instead.
- Use ref/state after the notifier was disposed.
  In this case, consider using `ref.onDispose` earlier in your notifier's lifecycle
  to abort any pending logic that could try to use `ref/state`.
''';

/// The prototype of `Notifier.build` overrides.
@internal
typedef RunNotifierBuild<NotifierT, CreatedT> = CreatedT Function(
  Ref ref,
  NotifierT notifier,
);

/// A base class for all "notifiers".
///
/// This is a good interface to target for writing mixins for Notifiers.
///
/// To perform logic before/after the `build` method of a notifier, you can override
/// [runBuild]:
///
/// ```dart
/// mixin MyMixin<T> extends NotifierBase<T, FutureOr<T>> {
///   @override
///   FutureOr<User> runBuild() {
///     // It is safe to use "ref" here.
///     ref.listenSelf((prev, next) => print("New state $next"));
///
///     // Before
///     final result = super.runBuild();
///     // After
///     return result;
///   }
/// }
/// ```
abstract class NotifierBase<StateT> {
  $Ref<StateT>? _ref;
  @protected
  Ref get ref => $ref;

  /// Listens to changes on the value exposed by this provider.
  ///
  /// The listener will be called immediately after the provider completes building.
  ///
  /// As opposed to [Ref.listen], the listener will be called even if
  /// [updateShouldNotify] returns false, meaning that the previous
  /// and new value can potentially be identical.
  ///
  /// Returns a function which can be called to remove the listener.
  @protected
  RemoveListener listenSelf(
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return $ref.listenSelf(listener, onError: onError);
  }

  @visibleForTesting
  @protected
  StateT get state => $ref.state;

  @visibleForTesting
  @protected
  set state(StateT newState) => $ref.state = newState;

  @visibleForOverriding
  bool updateShouldNotify(StateT previous, StateT next);

  @internal
  void runBuild();
}

mixin SyncPersistable<StateT> implements $Value<StateT, StateT> {
  @override
  (Object?,)? _debugKey;

  StateT _valueToState(StateT value) => value;

  FutureOr<void> _callEncode<KeyT, EncodedT>(
    Persist<KeyT, EncodedT> persist,
    KeyT key,
    EncodedT Function(StateT state) encode,
    PersistOptions options,
  ) {
    return persist.write(key, encode(state), options);
  }

  @override
  void persist<PersistT extends Persist<KeyT, EncodedT>, KeyT, EncodedT>(
    PersistT persist,
    KeyT key, {
    PersistOptions options = const PersistOptions(),
    required EncodedT Function(StateT state) encode,
    required StateT Function(EncodedT encoded) decode,
  }) {
    return _persist<PersistT, KeyT, EncodedT, StateT, StateT>(
      this,
      persist,
      key,
      encode: encode,
      decode: decode,
      options: options,
      valueToState: _valueToState,
      callEncode: _callEncode,
    );
  }
}

void _persist<PersistT extends Persist<KeyT, EncodedT>, KeyT, EncodedT, ValueT,
    StateT>(
  $Value<StateT, ValueT> self,
  PersistT persist,
  KeyT key, {
  PersistOptions options = const PersistOptions(),
  required EncodedT Function(ValueT state) encode,
  required ValueT Function(EncodedT encoded) decode,
  required StateT Function(ValueT value) valueToState,
  required FutureOr<void> Function(
    PersistT persist,
    KeyT key,
    EncodedT Function(ValueT state) encode,
    PersistOptions options,
  ) callEncode,
}) {
  _debugAssertNoDuplicateKey(key, self);

  var didChange = false;
  self.listenSelf((prev, next) async {
    didChange = true;

    try {
      callEncode(
        persist,
        key,
        encode,
        options,
      );
    } finally {
      didChange = false;
    }
  });

  if (self.ref.isFirstBuild) {
    try {
      // Let's read the Database
      persist.read(key).then((value) {
        // The state was initialized during the decoding, abort
        if (didChange) return;
        // Nothing to decode
        if (value == null) return;

        // New destroy key, so let's clear the cache.
        if (value.destroyKey != options.destroyKey) {
          persist.delete(key);
          return;
        }

        if (value.expireAt case final expireAt?) {
          final now = clock.now();
          if (expireAt.isBefore(now)) {
            persist.delete(key);
            return;
          }
        }

        final decoded = decode(value.data);
        self.state = valueToState(decoded);
      });
    } catch (err, stack) {
      // Don't block the provider if decoding failed
      Zone.current.handleUncaughtError(err, stack);
    }
  }
}

@internal
mixin AsyncPersistable<StateT> implements $Value<AsyncValue<StateT>, StateT> {
  @override
  (Object?,)? _debugKey;

  AsyncValue<StateT> _valueToState(StateT value) =>
      AsyncData(value, isFromCache: true);

  FutureOr<void> _callEncode<KeyT, EncodedT>(
    Persist<KeyT, EncodedT> persist,
    KeyT key,
    EncodedT Function(StateT state) encode,
    PersistOptions options,
  ) {
    switch (state) {
      case AsyncLoading():
        return null;
      case AsyncError():
        return persist.delete(key);
      case AsyncData(:final value):
        return persist.write(key, encode(value), options);
    }
  }

  @override
  void persist<PersistT extends Persist<KeyT, EncodedT>, KeyT, EncodedT>(
    PersistT persist,
    KeyT key, {
    PersistOptions options = const PersistOptions(),
    required EncodedT Function(StateT state) encode,
    required StateT Function(EncodedT encoded) decode,
  }) {
    return _persist<PersistT, KeyT, EncodedT, StateT, AsyncValue<StateT>>(
      this,
      persist,
      key,
      encode: encode,
      decode: decode,
      options: options,
      valueToState: _valueToState,
      callEncode: _callEncode,
    );
  }
}

@internal
mixin $Value<StateT, ValueT> on NotifierBase<StateT> {
  abstract (Object?,)? _debugKey;

  void persist<PersistT extends Persist<KeyT, EncodedT>, KeyT, EncodedT>(
    PersistT persist,
    KeyT key, {
    PersistOptions options = const PersistOptions(),
    required EncodedT Function(ValueT state) encode,
    required ValueT Function(EncodedT encoded) decode,
  });
}

void _debugAssertNoDuplicateKey<ValueT, StateT>(
  Object? key,
  $Value<ValueT, StateT> self,
) {
  if (kDebugMode) {
    self._debugKey = (key,);

    for (final element in self.ref.container.getAllProviderElements()) {
      if (element == self.element()) continue;
      if (element is! $ClassProviderElement) continue;

      final notifier = element.classListenable.result?.stateOrNull;
      if (notifier is! $Value) continue;

      final otherKey = notifier._debugKey;

      if (otherKey == self._debugKey) {
        Zone.current.handleUncaughtError(
          AssertionError('''
Duplicate `persistKey` found:
- `$key` from `${self.element()?.origin}`
- `$key` from `${element.origin}`

This means that two different providers are opted-in for offline persistence,
but both use the same `persistKey`.

Keys should be unique. To fix, change the `persistKey` of one of the providers
to a different value.
'''),
          StackTrace.current,
        );
      }
    }
  }
}

@internal
extension ClassBaseX<StateT> on NotifierBase<StateT> {
  $ClassProviderElement<NotifierBase<StateT>, StateT, Object?, Object?>?
      element() => _ref?.element as $ClassProviderElement<NotifierBase<StateT>,
          StateT, Object?, Object?>?;

  @internal
  // ignore: library_private_types_in_public_api, not public
  $Ref<StateT> get $ref {
    final ref = _ref;
    if (ref == null) throw StateError(uninitializedElementError);

    return ref;
  }
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
abstract base class $ClassProvider< //
    NotifierT extends NotifierBase<StateT>,
    StateT,
    ValueT,
    CreatedT> extends ProviderBase<StateT> {
  const $ClassProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
    required this.runNotifierBuildOverride,
  });

  Refreshable<NotifierT> get notifier {
    return ProviderElementProxy<NotifierT, StateT>(
      this,
      (element) => (element
              as $ClassProviderElement<NotifierT, StateT, ValueT, CreatedT>)
          .classListenable,
    );
  }

  @internal
  final RunNotifierBuild<NotifierT, CreatedT>? runNotifierBuildOverride;

  @internal
  NotifierT create();

  @visibleForOverriding
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> $copyWithCreate(
    NotifierT Function() create,
  );

  @visibleForOverriding
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> $copyWithBuild(
    RunNotifierBuild<NotifierT, CreatedT> build,
  );

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $copyWithCreate(create),
    );
  }

  /// {@template riverpod.override_with_build}
  /// Hello world
  /// {@endtemplate}
  Override overrideWithBuild(
    RunNotifierBuild<NotifierT, CreatedT> build,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $copyWithBuild(build),
    );
  }

  @override
  $ClassProviderElement< //
      NotifierT,
      StateT,
      ValueT,
      CreatedT> $createElement($ProviderPointer pointer);
}

@internal
abstract class $ClassProviderElement< //
        NotifierT extends NotifierBase<StateT>,
        StateT,
        ValueT,
        CreatedT> //
    extends ProviderElement<StateT> {
  $ClassProviderElement(super.pointer);

  @override
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> get provider;

  final classListenable = $ElementLense<NotifierT>();

  @mustCallSuper
  @override
  WhenComplete create(
    // ignore: library_private_types_in_public_api, not public
    $Ref<StateT> ref,
  ) {
    final result = classListenable.result = $Result.guard(() {
      final notifier = provider.create();
      if (notifier._ref != null) {
        throw StateError(alreadyInitializedError);
      }

      notifier._ref = ref;
      return notifier;
    });

    switch (result) {
      case ResultData():
        try {
          if (provider.runNotifierBuildOverride case final override?) {
            final created = override(ref, result.state);
            handleValue(ref, created);
          } else {
            result.state.runBuild();
          }
        } catch (err, stack) {
          handleError(ref, err, stack);
        }
      case ResultError():
        handleError(ref, result.error, result.stackTrace);
    }

    return null;
  }

  void handleValue(Ref ref, CreatedT created);
  void handleError(Ref ref, Object error, StackTrace stackTrace);

  @override
  bool updateShouldNotify(StateT previous, StateT next) {
    return classListenable.result?.stateOrNull
            ?.updateShouldNotify(previous, next) ??
        true;
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(classListenable);
  }
}
