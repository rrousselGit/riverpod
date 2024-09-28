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
typedef RunNotifierBuild< //
        NotifierT,
        CreatedT,
        RefT extends Ref<Object?>>
    = CreatedT Function(RefT ref, NotifierT notifier);

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
  Ref<StateT>? _ref;

  @protected
  Ref<StateT> get ref {
    final ref = _ref;
    if (ref == null) throw StateError(uninitializedElementError);

    return ref;
  }

  @visibleForTesting
  @protected
  StateT get state => ref.state;

  @visibleForTesting
  @protected
  set state(StateT newState) => ref.state = newState;

  CreatedT runBuild();

  @visibleForOverriding
  bool updateShouldNotify(StateT previous, StateT next);
}

@internal
extension ClassBaseX<StateT, CreatedT> on NotifierBase<StateT, CreatedT> {
  ProviderElement<StateT>? get element => _ref?._element;
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
abstract base class $ClassProvider< //
    NotifierT extends NotifierBase< //
        StateT,
        CreatedT>,
    StateT,
    CreatedT,
    RefT extends Ref<StateT>> extends ProviderBase<StateT> {
  const $ClassProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
    required super.persist,
    required this.runNotifierBuildOverride,
  });

  Refreshable<NotifierT> get notifier {
    return ProviderElementProxy<StateT, NotifierT>(
      this,
      (element) =>
          (element as ClassProviderElement<NotifierT, StateT, CreatedT>)
              .classListenable,
    );
  }

  @internal
  final RunNotifierBuild<NotifierT, CreatedT, RefT>? runNotifierBuildOverride;

  @internal
  NotifierT create();

  @visibleForOverriding
  $ClassProvider<NotifierT, StateT, CreatedT, RefT> $copyWithCreate(
    NotifierT Function() create,
  );

  @visibleForOverriding
  $ClassProvider<NotifierT, StateT, CreatedT, RefT> $copyWithBuild(
    RunNotifierBuild<NotifierT, CreatedT, RefT> build,
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
    RunNotifierBuild<NotifierT, CreatedT, RefT> build,
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
      CreatedT> $createElement($ProviderPointer pointer);
}

@internal
abstract class ClassProviderElement< //
        NotifierT extends NotifierBase< //
            StateT,
            CreatedT>,
        StateT,
        CreatedT> //
    extends ProviderElement<StateT> {
  ClassProviderElement(super.pointer);

  @override
  $ClassProvider<NotifierT, StateT, CreatedT, Ref<StateT>> get provider;

  final classListenable = ProxyElementValueListenable<NotifierT>();

  @mustCallSuper
  @override
  void create(
    Ref<StateT> ref, {
    required bool didChangeDependency,
  }) {
    final seamless = !didChangeDependency;

    final result = classListenable.result = Result.guard(() {
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
          handleNotifier(result.state, seamless: seamless);

          final created =
              provider.runNotifierBuildOverride?.call(ref, result.state) ??
                  result.state.runBuild();
          handleValue(created, seamless: seamless);
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
  }

  void handleNotifier(NotifierT notifier, {required bool seamless}) {
    // Overridden by FutureModifier mixin
  }

  void handleValue(CreatedT created, {required bool seamless});
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
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );
    listenableVisitor(classListenable);
  }
}
