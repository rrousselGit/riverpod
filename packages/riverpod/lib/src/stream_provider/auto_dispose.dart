part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeStreamProviderRef<State>
    extends StreamProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

/// {@macro riverpod.streamprovider}
class AutoDisposeStreamProvider<T> extends _StreamProviderBase<T>
    with AsyncSelector<T> {
  /// {@macro riverpod.streamprovider}
  AutoDisposeStreamProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamily.new;

  final Stream<T> Function(AutoDisposeStreamProviderRef<T> ref) _createFn;

  @override
  Stream<T> _create(AutoDisposeStreamProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeStreamProviderElement<T> createElement() {
    return AutoDisposeStreamProviderElement._(this);
  }

  @override
  late final Refreshable<Future<T>> future = _future(this);

  @override
  late final Refreshable<Stream<T>> stream = _stream(this);
}

/// The element of [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderElement<T> = StreamProviderElement<T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeStreamProviderRef<T>;

/// The [Family] of [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    AutoDisposeStreamProviderRef<R>,
    AsyncValue<R>,
    Arg,
    Stream<R>,
    AutoDisposeStreamProvider<R>> {
  /// The [Family] of [AutoDisposeStreamProvider].
  AutoDisposeStreamProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AutoDisposeStreamProvider.new);
}
