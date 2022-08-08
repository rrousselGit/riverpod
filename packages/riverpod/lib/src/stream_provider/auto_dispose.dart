part of '../stream_provider.dart';

abstract class AutoDisposeStreamProviderRef<State>
    extends StreamProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

class AutoDisposeStreamProvider<T> extends _StreamProviderBase<T> {
  AutoDisposeStreamProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  });

  static const family = AutoDisposeStreamProviderFamily.new;

  final Stream<T> Function(AutoDisposeStreamProviderRef<T> ref) _createFn;

  @override
  Stream<T> _create(AutoDisposeStreamProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeStreamProviderElement<T> createElement() {
    return AutoDisposeStreamProviderElement(this);
  }

  @override
  late final ProviderListenable<Future<T>> future = _future(this);

  @override
  late final ProviderListenable<Stream<T>> stream = _stream(this);
}

class AutoDisposeStreamProviderElement<T> = StreamProviderElement<T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeStreamProviderRef<T>;

class AutoDisposeStreamProviderFamily<R, Arg> extends FamilyBase<
    AutoDisposeStreamProviderRef<R>,
    AsyncValue<R>,
    Arg,
    Stream<R>,
    AutoDisposeStreamProvider<R>> {
  AutoDisposeStreamProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: AutoDisposeStreamProvider.new);
}
