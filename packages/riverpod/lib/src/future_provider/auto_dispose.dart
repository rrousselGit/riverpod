part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [FutureProviderRef.state], the value currently exposed by this provider.
abstract class AutoDisposeFutureProviderRef<State>
    extends FutureProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

/// {@macro riverpod.futureprovider}
class AutoDisposeFutureProvider<T> extends _FutureProviderBase<T>
    with AsyncSelector<T> {
  /// {@macro riverpod.futureprovider}
  AutoDisposeFutureProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeFutureProviderFamily.new;

  final FutureOr<T> Function(AutoDisposeFutureProviderRef<T> ref) _createFn;

  @override
  FutureOr<T> _create(AutoDisposeFutureProviderElement<T> ref) =>
      _createFn(ref);

  @override
  AutoDisposeFutureProviderElement<T> createElement() {
    return AutoDisposeFutureProviderElement._(this);
  }

  @override
  late final Refreshable<Future<T>> future = _future(this);
}

/// The [ProviderElementBase] of [AutoDisposeFutureProvider]
class AutoDisposeFutureProviderElement<T> = FutureProviderElement<T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeFutureProviderRef<T>;

/// The [Family] of an [AutoDisposeFutureProvider]
class AutoDisposeFutureProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    AutoDisposeFutureProviderRef<R>,
    AsyncValue<R>,
    Arg,
    FutureOr<R>,
    AutoDisposeFutureProvider<R>> {
  /// The [Family] of an [AutoDisposeFutureProvider]
  AutoDisposeFutureProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AutoDisposeFutureProvider.new);
}
