part of '../future_provider.dart';

abstract class AutoDisposeFutureProviderRef<State>
    extends FutureProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

class AutoDisposeFutureProvider<T> extends _FutureProviderBase<T> {
  AutoDisposeFutureProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  });

  static const family = AutoDisposeFutureProviderFamily.new;

  final FutureOr<T> Function(AutoDisposeFutureProviderRef<T> ref) _createFn;

  @override
  FutureOr<T> _create(AutoDisposeFutureProviderElement<T> ref) =>
      _createFn(ref);

  @override
  AutoDisposeFutureProviderElement<T> createElement() {
    return AutoDisposeFutureProviderElement(this);
  }

  @override
  late final ProviderListenable<Future<T>> future = _future(this);

  @override
  late final ProviderListenable<Stream<T>> stream = _stream(this);
}

class AutoDisposeFutureProviderElement<T> = FutureProviderElement<T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeFutureProviderRef<T>;

class AutoDisposeFutureProviderFamily<R, Arg> extends FFamily<
    AutoDisposeFutureProviderRef<R>,
    AsyncValue<R>,
    Arg,
    FutureOr<R>,
    AutoDisposeFutureProvider<R>> {
  AutoDisposeFutureProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: AutoDisposeFutureProvider.new);
}
