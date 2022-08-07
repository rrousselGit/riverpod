part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class StateProviderRef<State> implements Ref<State> {
  /// The [StateController] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  StateController<State> get controller;
}

class StateProvider<T> extends _StateProviderBase<T> {
  StateProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  final T Function(StateProviderRef<T> ref) _createFn;

  @override
  T _create(StateProviderElement<T> ref) => _createFn(ref);

  @override
  StateProviderElement<T> createElement() => StateProviderElement(this);

  @override
  late final AlwaysAliveProviderListenable<StateController<T>> notifier =
      _notifier(this);

  @override
  late final AlwaysAliveProviderListenable<StateController<T>> state =
      _state(this);
}

class StateProviderElement<T> extends ProviderElementBase<T>
    implements StateProviderRef<T> {
  StateProviderElement(_StateProviderBase<T> provider) : super(provider);

  @override
  StateController<T> get controller => _controllerNotifier.value;
  final _controllerNotifier = ValueNotifier<StateController<T>>();

  final _stateNotifier = ValueNotifier<StateController<T>>();

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
}

class StateProviderFamily<R, Arg>
    extends FFamily<StateProviderRef<R>, R, Arg, R, StateProvider<R>> {
  StateProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: StateProvider.new);
}
