part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class StateProviderRef<State> implements Ref<State> {
  /// The [StateController] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  StateController<State> get controller;
}

class StateProvider<T> extends _StateProviderBase<T>
    with AlwaysAliveProviderBase<T> {
  StateProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  static const autoDispose = AutoDisposeStateProviderBuilder();
  static const family = StateProviderFamilyBuilder();

  final T Function(StateProviderRef<T> ref) _createFn;

  @override
  T _create(StateProviderElement<T> ref) => _createFn(ref);

  @override
  StateProviderElement<T> createElement() => StateProviderElement._(this);

  @override
  late final AlwaysAliveRefreshable<StateController<T>> notifier =
      _notifier(this);

  @override
  late final AlwaysAliveRefreshable<StateController<T>> state = _state(this);
}

class StateProviderElement<T> extends ProviderElementBase<T>
    implements StateProviderRef<T> {
  StateProviderElement._(_StateProviderBase<T> provider) : super(provider);

  @override
  StateController<T> get controller => _controllerNotifier.value;
  final _controllerNotifier = ProxyElementValueNotifier<StateController<T>>();

  final _stateNotifier = ProxyElementValueNotifier<StateController<T>>();

  void Function()? _removeListener;

  @override
  void create() {
    final provider = this.provider as _StateProviderBase<T>;
    final initialState = provider._create(this);

    final controller = StateController(initialState);
    _controllerNotifier.result = Result.data(controller);

    _removeListener = controller.addListener((state) {
      _stateNotifier.result = _controllerNotifier.result;
      setState(state);
    }, fireImmediately: true);
  }

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    _controllerNotifier.result?.stateOrNull?.dispose();
    _controllerNotifier.result = null;
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_stateNotifier);
    notifierVisitor(_controllerNotifier);
  }
}

class StateProviderFamily<R, Arg>
    extends FamilyBase<StateProviderRef<R>, R, Arg, R, StateProvider<R>> {
  StateProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: StateProvider.new);
}
