part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class AutoDisposeStateProviderRef<State>
    extends StateProviderRef<State> implements AutoDisposeRef<State> {}

/// {@macro riverpod.stateprovider}
class AutoDisposeStateProvider<T> extends _StateProviderBase<T> {
  /// {@macro riverpod.stateprovider}
  AutoDisposeStateProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateProviderFamily.new;

  final T Function(AutoDisposeStateProviderRef<T> ref) _createFn;

  @override
  T _create(AutoDisposeStateProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeStateProviderElement<T> createElement() {
    return AutoDisposeStateProviderElement._(this);
  }

  @override
  late final Refreshable<StateController<T>> notifier = _notifier(this);

  @override
  late final Refreshable<StateController<T>> state = _state(this);
}

/// The element of [StateProvider].
class AutoDisposeStateProviderElement<T> = StateProviderElement<T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeStateProviderRef<T>;

/// The [Family] of [StateProvider].
class AutoDisposeStateProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    AutoDisposeStateProviderRef<R>, R, Arg, R, AutoDisposeStateProvider<R>> {
  /// The [Family] of [StateProvider].
  AutoDisposeStateProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AutoDisposeStateProvider.new);
}
