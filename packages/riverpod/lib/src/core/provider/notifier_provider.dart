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

/// Implementation detail of `riverpod_generator`.
/// Do not use.
abstract class $ClassBase<StateT, CreatedT> {
  ClassProviderElement<$ClassBase<StateT, CreatedT>, StateT, CreatedT>?
      _element;

  // TODO docs
  @protected
  Ref<StateT> get ref {
    final element = _element;
    if (element == null) throw StateError(uninitializedElementError);

    return element;
  }

  @visibleForTesting
  @protected
  StateT get state {
    final element = _element;
    if (element == null) throw StateError(uninitializedElementError);

    element.flush();
    return element.requireState;
  }

  @visibleForTesting
  @protected
  set state(StateT newState) {
    final element = _element;
    if (element == null) throw StateError(uninitializedElementError);

    element.state = newState;
  }

  @internal
  CreatedT runBuild();

  @visibleForOverriding
  bool updateShouldNotify(StateT previous, StateT next);
}

@internal
extension ClassBaseX<StateT, CreatedT> on $ClassBase<StateT, CreatedT> {
  ClassProviderElement<$ClassBase<StateT, CreatedT>, StateT, CreatedT>?
      get element => _element;
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
abstract base class $ClassProvider< //
    NotifierT extends $ClassBase< //
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

  // TODO docs
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
      CreatedT> $createElement(ProviderContainer container);
}

@internal
abstract class ClassProviderElement< //
        NotifierT extends $ClassBase< //
            StateT,
            CreatedT>,
        StateT,
        CreatedT> //
    extends ProviderElementBase<StateT> {
  ClassProviderElement(super.container);

  @override
  $ClassProvider<NotifierT, StateT, CreatedT, Ref<StateT>> get provider;

  final classListenable = ProxyElementValueListenable<NotifierT>();

  @mustCallSuper
  @override
  void create({required bool didChangeDependency}) {
    final result = classListenable.result ??= Result.guard(() {
      final notifier = provider.create();
      if (notifier._element != null) {
        throw StateError(alreadyInitializedError);
      }

      notifier._element = this;
      return notifier;
    });

    // TODO test notifier constructor throws -> provider emits AsyncError
    // TODO test notifier constructor throws -> .notifier rethrows the error
    // TODO test notifier constructor throws -> .future emits Future.error

    switch (result) {
      case ResultData():
        try {
          handleNotifier(result.state, seamless: !didChangeDependency);

          final created =
              provider.runNotifierBuildOverride?.call(this, result.state) ??
                  result.state.runBuild();
          handleValue(created, didChangeDependency: didChangeDependency);
        } catch (err, stack) {
          handleError(err, stack, didChangeDependency: didChangeDependency);
        }
      case ResultError():
        handleError(
          result.error,
          result.stackTrace,
          didChangeDependency: didChangeDependency,
        );
    }
  }

  void handleNotifier(NotifierT notifier, {required bool seamless}) {
    // Overridden by FutureModifier mixin
  }

  void handleValue(CreatedT created, {required bool didChangeDependency});
  void handleError(
    Object error,
    StackTrace stackTrace, {
    required bool didChangeDependency,
  });

  @override
  void dispose() {
    super.dispose();
    classListenable.result?.stateOrNull?._element = null;
  }

  @override
  bool updateShouldNotify(StateT previous, StateT next) {
    return classListenable.result?.stateOrNull
            ?.updateShouldNotify(previous, next) ??
        true;
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase<Object?> element) elementVisitor,
    required void Function(ProxyElementValueListenable<Object?> element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );
    listenableVisitor(classListenable);
  }
}
