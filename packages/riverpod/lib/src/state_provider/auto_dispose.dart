part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class AutoDisposeStateProviderRef<State>
    extends StateProviderRef<State> implements AutoDisposeRef<State> {}

class AutoDisposeStateProvider<T> extends _StateProviderBase<T> {
  AutoDisposeStateProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  });

  static const family = AutoDisposeStateProviderFamily.new;

  final T Function(AutoDisposeStateProviderRef<T> ref) _createFn;

  @override
  T _create(AutoDisposeStateProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeStateProviderElement<T> createElement() {
    return AutoDisposeStateProviderElement(this);
  }

  @override
  late final ProviderListenable<StateController<T>> notifier = _notifier(this);

  @override
  late final ProviderListenable<StateController<T>> state = _state(this);
}

class AutoDisposeStateProviderElement<T> = StateProviderElement<T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeStateProviderRef<T>;

class AutoDisposeStateProviderFamily<R, Arg> extends FFamily<
    AutoDisposeStateProviderRef<R>, R, Arg, R, AutoDisposeStateProvider<R>> {
  AutoDisposeStateProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: AutoDisposeStateProvider.new);
}
