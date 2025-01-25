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
  void runBuild({
    required bool isFirstBuild,
    required bool didChangeDependency,
  });
}

@internal
mixin $Value<ValueT> {}

@internal
extension ClassBaseX<StateT> on NotifierBase<StateT> {
  ClassProviderElement<NotifierBase<StateT>, StateT, Object?, Object?>?
      element() => _ref?._element as ClassProviderElement<NotifierBase<StateT>,
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
      (element) =>
          (element as ClassProviderElement<NotifierT, StateT, ValueT, CreatedT>)
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
  ClassProviderElement< //
      NotifierT,
      StateT,
      ValueT,
      CreatedT> $createElement($ProviderPointer pointer);
}

@internal
abstract class ClassProviderElement< //
        NotifierT extends NotifierBase<StateT>,
        StateT,
        ValueT,
        CreatedT> //
    extends ProviderElement<StateT> {
  ClassProviderElement(super.pointer);

  @override
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> get provider;

  final classListenable = $ElementLense<NotifierT>();

  @mustCallSuper
  @override
  WhenComplete create(
    // ignore: library_private_types_in_public_api, not public
    $Ref<StateT> ref, {
    required bool didChangeDependency,
    required bool isFirstBuild,
  }) {
    final seamless = !didChangeDependency;

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
          if (isFirstBuild) _decodeFromCache();

          if (provider.runNotifierBuildOverride case final override?) {
            final created = override(ref, result.state);
            handleValue(
              created,
              seamless: seamless,
              isFirstBuild: isFirstBuild,
            );
          } else {
            result.state.runBuild(
              isFirstBuild: isFirstBuild,
              didChangeDependency: didChangeDependency,
            );
          }
        } catch (err, stack) {
          handleError(err, stack, seamless: seamless);
        }
      case ResultError():
        handleError(
          result.error,
          result.stackTrace,
          seamless: seamless,
        );
    }

    return null;
  }

  void _decodeFromCache() {
    final adapter = _adapter();
    if (adapter == null) return;

    _decode(adapter);

    ref!.listenSelf((previous, current) => _callEncode(adapter));
  }

  NotifierEncoder<Object?, ValueT, Object?>? _adapter() {
    final Object? notifier = classListenable.result?.stateOrNull;

    switch (notifier) {
      case NotifierEncoder<Object?, ValueT, Object?>():
        return notifier;
      default:
        return null;
    }
  }

  Persist? _requestPersist(NotifierEncoder<Object?, ValueT, Object?> adapter) {
    final persist = adapter.persist;

    if (kDebugMode) _debugAssertNoDuplicateKey(adapter.persistKey);

    return persist;
  }

  void _debugAssertNoDuplicateKey(Object? key) {
    if (kDebugMode) {
      for (final element in container.getAllProviderElements()) {
        if (element == this) continue;
        if (element is! ClassProviderElement) continue;

        final otherKey = element._adapter()?.persistKey;

        if (otherKey == key) {
          Zone.current.handleUncaughtError(
            AssertionError('''
Duplicate `persistKey` found:
- `$key` from `$origin`
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

  void callDecode(
    NotifierEncoder<Object?, ValueT, Object?> adapter,
    Object? encoded,
  );

  FutureOr<void> _decode(
    NotifierEncoder<Object?, ValueT, Object?> adapter,
  ) async {
    final offline = _requestPersist(adapter);
    if (offline == null) return;
    final persist = offline;

    try {
      final key = adapter.persistKey;
      final initialResult = stateResult;
      await persist.read(key).then((data) {
        if (!identical(initialResult, stateResult)) return;
        if (data == null) return;

        final options = adapter.persistOptions;
        if (data.destroyKey != options.destroyKey) {
          persist.delete(key);
          return;
        }

        if (data.expireAt case final expireAt?) {
          final now = clock.now();
          if (expireAt.isBefore(now)) {
            persist.delete(key);
            return;
          }
        }

        callDecode(adapter, data.data);
        // TODO If decode throws, should we set the state as an error?
      });
    } catch (e, s) {
      Zone.current.handleUncaughtError(e, s);
    }
  }

  Future<void> callEncode(
    Persist persist,
    NotifierEncoder<Object?, ValueT, Object?> adapter,
  );

  Future<void> _callEncode(
    NotifierEncoder<Object?, ValueT, Object?> adapter,
  ) async {
    final offline = _requestPersist(adapter);
    if (offline == null) return;
    final persist = offline;

    try {
      await callEncode(persist, adapter);
    } catch (e, s) {
      Zone.current.handleUncaughtError(e, s);
    }
  }

  void handleValue(
    CreatedT created, {
    required bool seamless,
    required bool isFirstBuild,
  });
  void handleError(
    Object error,
    StackTrace stackTrace, {
    required bool seamless,
  });

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
