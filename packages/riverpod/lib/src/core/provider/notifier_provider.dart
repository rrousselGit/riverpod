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
/// mixin MyMixin<T> extends AnyNotifier<T, FutureOr<T>> {
///   @override
///   void runBuild() {
///     // It is safe to use "ref" here.
///     listenSelf((prev, next) => print("New state $next"));
///
///     print('Before build');
///     super.runBuild();
///     print('After build');
///   }
/// }
/// ```
/// {@category Notifiers}
@publicInRiverpodAndCodegen
mixin AnyNotifier<StateT, ValueT> {
  (Object?,)? _debugKey;

  $ClassProviderElement<AnyNotifier<StateT, ValueT>, StateT, ValueT, Object?>?
      _element;

  /// The [Ref] associated with this notifier.
  @protected
  Ref get ref => $ref;

  /// The value currently exposed by this notifier.
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  ///
  /// Reading [state] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [Notifier.build] to be re-executed.
  ///
  /// **Warning**:
  /// Inside synchronous notifiers ([Notifier]), reading [state] withing [Notifier.build]
  /// may throw an exception if done before calling [state=].
  /// Asynchronous notifiers ([AsyncNotifier]) are not affected by this, as they
  /// initialize their state to [AsyncLoading] before calling [Notifier.build].
  ///
  /// **Warning**:
  /// Inside synchronous providers, reading [state] may throw if  [Notifier.build] threw.
  /// Asynchronous notifiers will instead convert the error into an [AsyncError].
  @visibleForTesting
  @protected
  StateT get state => $ref.state;

  @visibleForTesting
  @protected
  set state(StateT newState) => $ref.state = newState;

  void _setStateFromValue(ValueT value);

  FutureOr<void> _callEncode<KeyT, EncodedT>(
    FutureOr<Storage<KeyT, EncodedT>> storage,
    KeyT key,
    EncodedT Function(ValueT state) encode,
    StorageOptions options,
  );

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

  /// A method invoked when the state exposed by this [Notifier] changes.
  /// It compares the previous and new value, and return whether listeners
  /// should be notified.
  ///
  /// By default, the previous and new value are compared using [==].
  ///
  /// You can override this method to provide a custom comparison logic,
  /// such as using [identical] to use a more efficient comparison.
  @visibleForOverriding
  bool updateShouldNotify(StateT previous, StateT next) {
    return ProviderElement.defaultUpdateShouldNotify(previous, next);
  }

  /// Executes [Notifier.build].
  ///
  /// This is called by Riverpod, and should not be called manually.
  /// The purpose of this method is to allow mixins to perform logic
  /// before/after the `build` method of a notifier.
  ///
  /// For example, you could implement a mixin that logs state changes:
  ///
  /// ```dart
  /// mixin LoggingMixin<T> on AnyNotifier<T> {
  ///   @override
  ///   void runBuild() {
  ///     print('Will build $this');
  ///     super.runBuild();
  ///     print('Did build $this');
  ///   }
  /// }
  /// ```
  ///
  /// The benefit of this method is that it applies on all notifiers,
  /// regardless of whether they use arguments or not.
  @mustCallSuper
  void runBuild();

  void _debugAssertNoDuplicateKey(
    Object? key,
    AnyNotifier<Object?, Object?> self,
  ) {
    if (kDebugMode) {
      final selfElement = (self as AnyNotifier).elementOrNull();

      self._debugKey = (key,);

      for (final element in self.ref.container.getAllProviderElements()) {
        if (element == selfElement) continue;
        if (element is! $ClassProviderElement) continue;

        final notifier = element.classListenable.result?.value;
        if (notifier == null) continue;

        final otherKey = notifier._debugKey;

        if (otherKey == self._debugKey) {
          ref.container.defaultOnError(
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
}

/// Metadata about offline persistence.
///
/// This generally should be ignored. But for specific use-cases, Notifiers
/// may want to use this object to await [future].
@publicInPersist
final class PersistResult {
  PersistResult._({required this.future});

  /// A future that completes when the persisted state has been decoded
  /// (or null if no decoding was performed).
  final Future<void>? future;
}

/// Adds [persist] method to [AnyNotifier].
///
/// This is separate from [AnyNotifier] because it is experimental.
@publicInPersist
extension NotifierPersistX<StateT, ValueT> on AnyNotifier<StateT, ValueT> {
  /// Persist the state of a provider to a database.
  ///
  /// When calling this method, Riverpod will automatically listen to state
  /// changes, and invoke [Storage] methods to persist the state.
  ///
  /// It is generally recommended to call this method at the very top of
  /// [Notifier.build] This will ensure that the state is persisted as soon as possible.
  ///
  /// Calling [persist] returns [PersistResult] that contains a [Future]
  /// which completes when decoding has finished. See [PersistResult.future].
  /// In general, you should not await this future, as awaiting it would
  /// only delay the core logic, such as fetching data from an API.
  ///
  /// **Note**:
  /// The decoding of the state is only performed once, the first time
  /// the provider is built. Calling [persist] multiple times will not
  /// re-trigger the decoding.
  PersistResult persist<KeyT, EncodedT>(
    FutureOr<Storage<KeyT, EncodedT>> storage, {
    required KeyT key,
    required EncodedT Function(ValueT state) encode,
    required ValueT Function(EncodedT encoded) decode,
    StorageOptions options = const StorageOptions(),
  }) {
    _debugAssertNoDuplicateKey(key, this);

    var didChange = false;
    listenSelf((_, __) async {
      didChange = true;

      try {
        final futureOr = _callEncode(
          storage,
          key,
          encode,
          options,
        );
        if (futureOr is Future) {
          unawaited(futureOr.onError(ref.container.defaultOnError));
        }
      } finally {
        didChange = false;
      }
    });

    if (ref.isFirstBuild) {
      try {
        // Let's read the Database
        final futureOr = storage.then(
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

        if (futureOr is Future) {
          return PersistResult._(
            future: futureOr.catchError(ref.container.defaultOnError),
          );
        }
      } catch (err, stack) {
        // Don't block the provider if decoding failed
        ref.container.defaultOnError(err, stack);
      }
    }

    return PersistResult._(future: null);
  }
}

@internal
abstract class $AsyncNotifierBase<ValueT>
    with AnyNotifier<AsyncValue<ValueT>, ValueT> {
  @override
  void _setStateFromValue(ValueT value) {
    state = AsyncData(value, isFromCache: true);
  }

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
abstract class $SyncNotifierBase<ValueT> with AnyNotifier<ValueT, ValueT> {
  @override
  void _setStateFromValue(ValueT value) => state = value;

  @override
  FutureOr<void> _callEncode<KeyT, EncodedT>(
    FutureOr<Storage<KeyT, EncodedT>> storage,
    KeyT key,
    EncodedT Function(ValueT state) encode,
    StorageOptions options,
  ) {
    return storage
        .then((storage) => storage.write(key, encode(state), options));
  }
}

@internal
extension ClassBaseX<StateT, ValueT> on AnyNotifier<StateT, ValueT> {
  $ClassProviderElement<AnyNotifier<StateT, ValueT>, StateT, Object?, Object?>?
      elementOrNull() => _element;

  $ClassProviderElement<AnyNotifier<StateT, ValueT>, StateT, Object?, Object?>
      requireElement() {
    final element = elementOrNull();
    if (element == null) {
      throw StateError(uninitializedElementError);
    }

    ref._throwIfInvalidUsage();

    return element;
  }

  @internal
  // ignore: library_private_types_in_public_api, not public
  $Ref<StateT, ValueT> get $ref {
    final ref = _element?.ref;
    if (ref == null) throw StateError(uninitializedElementError);

    return ref;
  }
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
@reopen
@publicInCodegen
abstract base class $ClassProvider< //
    NotifierT extends AnyNotifier<StateT, ValueT>,
    StateT,
    ValueT,
    CreatedT> extends $ProviderBaseImpl<StateT> {
  const $ClassProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.$allTransitiveDependencies,
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

  /// @nodoc
  @internal
  NotifierT create();

  /// @nodoc
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

  /// @nodoc
  @internal
  @override
  $ClassProviderElement< //
      NotifierT,
      StateT,
      ValueT,
      CreatedT> $createElement($ProviderPointer pointer);
}

final class _ClassProviderView<
    NotifierT extends AnyNotifier<StateT, ValueT>,
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
          $allTransitiveDependencies: _inner.$allTransitiveDependencies,
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

  /// @nodoc
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
@publicInCodegen
abstract class $ClassProviderElement< //
        NotifierT extends AnyNotifier<StateT, ValueT>,
        StateT,
        ValueT,
        CreatedT> //
    extends ProviderElement<StateT, ValueT> with ElementWithFuture {
  $ClassProviderElement(super.pointer)
      : provider = pointer.origin
            as $ClassProvider<NotifierT, StateT, ValueT, CreatedT>;

  @override
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> provider;
  RunNotifierBuild<NotifierT, CreatedT>? _runNotifierBuildOverride;

  final classListenable = $Observable<NotifierT>();

  @mustCallSuper
  @override
  WhenComplete create(
    // ignore: library_private_types_in_public_api, not public
    $Ref<StateT, ValueT> ref,
  ) {
    final result = classListenable.result ??= $Result.guard(() {
      final notifier = provider.create();
      if (notifier._element != null) {
        throw StateError(alreadyInitializedError);
      }

      notifier._element = this;
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
        super.updateShouldNotify(previous, next);
  }

  @override
  ProviderObserverContext _currentObserverContext() {
    return ProviderObserverContext(
      origin,
      container,
      mutation: _currentMutationContext(),
    );
  }

  @override
  void visitListenables(
    void Function($Observable element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(classListenable);
  }
}
