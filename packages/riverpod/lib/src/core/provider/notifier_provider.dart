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
mixin AnyNotifier<StateT> {
  ProviderElementBase<StateT>? _ref;

  /// Documented in subclass
  @protected
  Ref<StateT> get ref => $ref;

  /// {@template riverpod.listen_self}
  /// Listens to changes on the value exposed by this provider.
  ///
  /// The listener will be called immediately after the provider completes building.
  ///
  /// As opposed to [Ref.listen], the listener will be called even if
  /// [updateShouldNotify] returns false, meaning that the previous
  /// and new value can potentially be identical.
  ///
  /// Returns a function which can be called to remove the listener.
  /// {@endtemplate}
  @protected
  void Function() listenSelf(
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return $ref.listenSelf(listener, onError: onError);
  }

  /// Documented in subclass
  @visibleForTesting
  @protected
  StateT get state;

  @visibleForTesting
  @protected
  set state(StateT newState);

  /// Documented in subclass
  @visibleForOverriding
  bool updateShouldNotify(StateT previous, StateT next);

  /// Internal, do not use.
  @internal
  void runBuild();
}

@internal
abstract class $AsyncNotifierBase<ValueT>
    with AnyNotifier<AsyncValue<ValueT>> {}

@internal
abstract class $SyncNotifierBase<StateT> with AnyNotifier<StateT> {}

@internal
extension ClassBaseX<StateT> on AnyNotifier<StateT> {
  $ClassProviderElement<AnyNotifier<StateT>, StateT, Object?, Object?>?
      element() => _ref as $ClassProviderElement<AnyNotifier<StateT>, StateT,
          Object?, Object?>?;

  @internal
  // ignore: library_private_types_in_public_api, not public
  Ref<StateT> get $ref {
    final ref = _ref;
    if (ref == null) throw StateError(uninitializedElementError);

    return ref;
  }
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
abstract base class $ClassProvider< //
    NotifierT extends AnyNotifier<StateT>,
    StateT,
    ValueT,
    CreatedT> extends ProviderBase<StateT> {
  const $ClassProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required this.runNotifierBuildOverride,
    required super.debugGetCreateSourceHash,
  });

  Refreshable<NotifierT> get notifier {
    return ProviderElementProxy<StateT, NotifierT>(
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
    return ProviderOverride(
      origin: this,
      override: $copyWithCreate(create),
    );
  }

  /// {@template riverpod.override_with_build}
  /// Enables overriding the `build` method of a notifier.
  ///
  /// This overrides the `build` method of the notifier, without overriding
  /// anything else in the notifier.
  /// This is useful to mock the initialization logic of a notifier inside tests,
  /// but to keep the rest of the notifier intact.
  /// {@endtemplate}
  Override overrideWithBuild(
    RunNotifierBuild<NotifierT, CreatedT> build,
  ) {
    return ProviderOverride(
      origin: this,
      override: $copyWithBuild(build),
    );
  }

  @override
  $ClassProviderElement<NotifierT, StateT, ValueT, CreatedT> createElement();
}

@internal
abstract class $ClassProviderElement< //
        NotifierT extends AnyNotifier<StateT>,
        StateT,
        ValueT,
        CreatedT> //
    extends ProviderElementBase<StateT> {
  $ClassProviderElement(super._provider);

  @override
  $ClassProvider<NotifierT, StateT, ValueT, CreatedT> get provider;

  final classListenable = $ElementLense<NotifierT>();

  @mustCallSuper
  @override
  void create({required bool didChangeDependency}) {
    final result = classListenable.result ??= $Result.guard(() {
      final notifier = provider.create();
      if (notifier._ref != null) {
        throw StateError(alreadyInitializedError);
      }

      notifier._ref = this;
      return notifier;
    });

    switch (result) {
      case $ResultData():
        try {
          if (provider.runNotifierBuildOverride case final override?) {
            final created = override(this, result.value);
            handleValue(this, created);
          } else {
            result.value.runBuild();
          }
        } catch (err, stack) {
          handleError(this, err, stack);
        }
      case $ResultError():
        handleError(this, result.error, result.stackTrace);
    }
  }

  void handleValue(Ref<StateT> ref, CreatedT created);
  void handleError(Ref<StateT> ref, Object error, StackTrace stackTrace);

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
