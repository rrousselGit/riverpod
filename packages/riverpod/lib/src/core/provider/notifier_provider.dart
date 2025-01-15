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
/// - [StateT] is the type of [state].
/// - [CreatedT] is the type of the value returned by the notifier's `build` method.
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
abstract class NotifierBase<StateT, CreatedT> {
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

  CreatedT runBuild();

  @visibleForOverriding
  bool updateShouldNotify(StateT previous, StateT next);
}

@internal
extension ClassBaseX<StateT, CreatedT> on NotifierBase<StateT, CreatedT> {
  ProviderElement<StateT>? get element => _ref?._element;

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
    NotifierT extends NotifierBase< //
        StateT,
        CreatedT>,
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
    required super.persistOptions,
    required super.shouldPersist,
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
        NotifierT extends NotifierBase< //
            StateT,
            CreatedT>,
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
    required bool isMount,
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
          if (isMount) _decodeFromCache();

          final created =
              provider.runNotifierBuildOverride?.call(ref, result.state) ??
                  result.state.runBuild();
          handleValue(
            created,
            seamless: seamless,
            isMount: isMount,
          );
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
    if (!origin.shouldPersist) return;

    _decode();

    ref!.listenSelf((previous, current) => _callEncode());
  }

  (NotifierEncoder<ValueT, Persist<Object?, ValueT>>, Persist<Object?, ValueT>)?
      _requestPersist() {
    final adapter = classListenable.result?.stateOrNull
        as NotifierEncoder<ValueT, Persist<Object?, ValueT>>?;
    if (adapter == null) return null;

    final persist = adapter.optionsFor(container, provider);
    if (persist == null) {
      throw StateError(
        'The provider $origin asked to be persisted on device, but no Persist found.'
        ' When using offline persistence, you must provide either ProviderContainer.persistOptions or MyProvider.persistOptions.',
      );
    }

    return (adapter, persist);
  }

  void callDecode(NotifierEncoder<ValueT, Persist<Object?, ValueT>> adapter,
      Object? encoded);

  FutureOr<void> _decode() async {
    final offline = _requestPersist();
    if (offline == null) return;
    final (adapter, persist) = offline;

    try {
      final key = adapter.persistKey;
      final initialResult = stateResult;
      await persist.read(key).then((encoded) {
        if (!identical(initialResult, stateResult)) return;
        if (encoded == null) return;

        callDecode(adapter, encoded.$1);
        // TODO If decode throws, should we set the state as an error?
      });
    } catch (e, s) {
      Zone.current.handleUncaughtError(e, s);
    }
  }

  Future<void> _callEncode() async {
    final offline = _requestPersist();
    if (offline == null) return;
    final (adapter, persist) = offline;

    try {
      final key = adapter.persistKey;
      await persist.write(key, adapter.encode());
    } catch (e, s) {
      Zone.current.handleUncaughtError(e, s);
    }
  }

  void handleValue(
    CreatedT created, {
    required bool seamless,
    required bool isMount,
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
