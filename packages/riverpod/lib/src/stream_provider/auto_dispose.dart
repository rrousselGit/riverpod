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

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    Create<Stream<T>, AutoDisposeStreamProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStreamProvider<T>(
        create,
        from: from,
        argument: argument,
      ),
    );
  }
}

/// The element of [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderElement<T> extends StreamProviderElement<T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeStreamProviderRef<T> {
  /// The [ProviderElementBase] for [StreamProvider]
  AutoDisposeStreamProviderElement._(
    AutoDisposeStreamProvider<T> super.provider,
  ) : super._();
}

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

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    Stream<R> Function(AutoDisposeStreamProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, AutoDisposeStreamProvider<R>>(
      this,
      (arg) => AutoDisposeStreamProvider<R>(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
      ),
    );
  }
}
