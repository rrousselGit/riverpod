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

@internal
abstract class $Value<ValueT> {
  Ref get ref;
  (Object?,)? _debugKey;

  void _setStateFromValue(ValueT value);

  FutureOr<void> _callEncode<KeyT, EncodedT>(
    FutureOr<Storage<KeyT, EncodedT>> storage,
    KeyT key,
    EncodedT Function(ValueT state) encode,
    StorageOptions options,
  );

  void Function() _listenSelfFromValue(
    void Function() listener,
  );
}

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
mixin NotifierBase<StateT> {
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

@internal
abstract class $AsyncNotifierBase<ValueT> extends $Value<ValueT>
    with NotifierBase<AsyncValue<ValueT>> {
  @override
  void _setStateFromValue(ValueT value) {
    state = AsyncData(value, isFromCache: true);
  }

  @override
  void Function() _listenSelfFromValue(void Function() listener) =>
      listenSelf((previous, next) => listener());

  @override
  FutureOr<void> _callEncode<KeyT, EncodedT>(
    FutureOr<Storage<KeyT, EncodedT>> storage,
    KeyT key,
    EncodedT Function(ValueT state) encode,
    StorageOptions options,
  ) {
    switch (state) {
      case AsyncLoading():
        return null;
      case AsyncError():
        return storage.then((storage) => storage.delete(key));
      case AsyncData(:final value):
        return storage
            .then((storage) => storage.write(key, encode(value), options));
    }
  }
}

@internal
abstract class $SyncNotifierBase<StateT> extends $Value<StateT>
    with NotifierBase<StateT> {
  @override
  void _setStateFromValue(StateT value) => state = value;

  @override
  void Function() _listenSelfFromValue(void Function() listener) =>
      listenSelf((previous, next) => listener());

  @override
  FutureOr<void> _callEncode<KeyT, EncodedT>(
    FutureOr<Storage<KeyT, EncodedT>> storage,
    KeyT key,
    EncodedT Function(StateT state) encode,
    StorageOptions options,
  ) {
    return storage
        .then((storage) => storage.write(key, encode(state), options));
  }
}

mixin Persistable<ValueT, KeyT, EncodedT> on $Value<ValueT> {
  void _debugAssertNoDuplicateKey(
    Object? key,
    $Value<Object?> self,
  ) {
    if (kDebugMode) {
      final selfElement = (self as NotifierBase).element();

      self._debugKey = (key,);

      for (final element in self.ref.container.getAllProviderElements()) {
        if (element == selfElement) continue;
        if (element is! $ClassProviderElement) continue;

        final Object? notifier = element.classListenable.result?.value;
        if (notifier is! $Value) continue;

        final otherKey = notifier._debugKey;

        if (otherKey == self._debugKey) {
          Zone.current.handleUncaughtError(
            AssertionError('''
Duplicate `persistKey` found:
- `$key` from `${selfElement?.origin}`
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

  FutureOr<void> persist({
    required KeyT key,
    required FutureOr<Storage<KeyT, EncodedT>> storage,
    required EncodedT Function(ValueT state) encode,
    required ValueT Function(EncodedT encoded) decode,
    StorageOptions options = const StorageOptions(),
  }) {
    _debugAssertNoDuplicateKey(key, this);

    var didChange = false;
    _listenSelfFromValue(() async {
      didChange = true;

      try {
        _callEncode(
          storage,
          key,
          encode,
          options,
        );
      } finally {
        didChange = false;
      }
    });

    if (ref.isFirstBuild) {
      try {
        // Let's read the Database
        return storage.then(
          (storage) => storage.read(key).then((value) {
            // The state was initialized during the decoding, abort
            if (didChange) return null;
            // Nothing to decode
            if (value == null) return null;

            // New destroy key, so let's clear the cache.
            if (value.destroyKey != options.destroyKey) {
              return storage.delete(key);
            }

            if (value.expireAt case final expireAt?) {
              final now = clock.now();
              if (expireAt.isBefore(now)) {
                return storage.delete(key);
              }
            }

            final decoded = decode(value.data);
            _setStateFromValue(decoded);
          }),
        );
      } catch (err, stack) {
        // Don't block the provider if decoding failed
        Zone.current.handleUncaughtError(err, stack);
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
@internal
@reopen
@Public.inLibrary('riverpod_annotation')
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
  NotifierT create();

  @internal
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> $view({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, CreatedT>? runNotifierBuildOverride,
  }) {
    return _ClassProviderView(
      this,
      create: create,
      runNotifierBuildOverride: runNotifierBuildOverride,
    );
  }

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $view(create: create),
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
      providerOverride: $view(runNotifierBuildOverride: build),
    );
  }

  @internal
  @override
  $ClassProviderElement< //
      NotifierT,
      StateT,
      ValueT,
      CreatedT> $createElement($ProviderPointer pointer);
}

final class _ClassProviderView<
    NotifierT extends NotifierBase<StateT>,
    StateT,
    ValueT,
    CreatedT> extends $ClassProvider<NotifierT, StateT, ValueT, CreatedT> {
  _ClassProviderView(
    this._inner, {
    RunNotifierBuild<NotifierT, CreatedT>? runNotifierBuildOverride,
    NotifierT Function()? create,
  })  : _create = create,
        _runNotifierBuildOverride = runNotifierBuildOverride,
        assert(
          create != null || runNotifierBuildOverride != null,
          'Either `create` or `runNotifierBuildOverride` must be provided.',
        ),
        super(
          name: _inner.name,
          from: _inner.from,
          argument: _inner.argument,
          dependencies: _inner.dependencies,
          allTransitiveDependencies: _inner.allTransitiveDependencies,
          retry: _inner.retry,
          isAutoDispose: _inner.isAutoDispose,
        );

  final $ClassProvider<NotifierT, StateT, ValueT, CreatedT> _inner;

  final NotifierT Function()? _create;
  final RunNotifierBuild<NotifierT, CreatedT>? _runNotifierBuildOverride;

  @override
  NotifierT create() {
    if (_create != null) return _create();

    return _inner.create();
  }

  @internal
  @override
  $ClassProviderElement<NotifierT, StateT, ValueT, CreatedT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _inner.$createElement(pointer)
      ..provider = this
      .._runNotifierBuildOverride = _runNotifierBuildOverride;
  }

  @override
  String? debugGetCreateSourceHash() => _inner.debugGetCreateSourceHash();
}

@internal
@Public.inLibrary('riverpod_annotation')
abstract class $ClassProviderElement< //
        NotifierT extends NotifierBase<StateT>,
        StateT,
        ValueT,
        CreatedT> //
    extends ProviderElement<StateT> {
  $ClassProviderElement(super.pointer)
      : provider = pointer.origin
            as $ClassProvider<NotifierT, StateT, ValueT, CreatedT>;

  @override
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> provider;
  RunNotifierBuild<NotifierT, CreatedT>? _runNotifierBuildOverride;

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
      case $ResultData():
        try {
          if (_runNotifierBuildOverride case final override?) {
            final created = override(ref, result.value);
            handleValue(ref, created);
          } else {
            result.value.runBuild();
          }
        } catch (err, stack) {
          handleError(ref, err, stack);
        }
      case $ResultError():
        handleError(ref, result.error, result.stackTrace);
    }

    return null;
  }

  void handleValue(Ref ref, CreatedT created);
  void handleError(Ref ref, Object error, StackTrace stackTrace);

  @override
  bool updateShouldNotify(StateT previous, StateT next) {
    return classListenable.result?.value?.updateShouldNotify(previous, next) ??
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
