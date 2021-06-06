part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [state], the value currently exposed by this providers.
typedef AutoDisposeStreamProviderRef<State>
    = AutoDisposeProviderRef<AsyncValue<State>>;

/// {@macro riverpod.streamprovider}
@sealed
class AutoDisposeStreamProvider<State>
    extends AutoDisposeProviderBase<AsyncValue<State>>
    with
        AutoDisposeProviderOverridesMixin<AsyncValue<State>>,
        _StreamProviderMixin<State> {
  /// {@macro riverpod.streamprovider}
  AutoDisposeStreamProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamilyBuilder();

  final Create<Stream<State>, AutoDisposeStreamProviderRef<State>> _create;

  @override
  late final AutoDisposeProviderBase<Stream<State>> stream =
      AutoDisposeProvider((ref) {
    return asyncValueToStream(this, ref as ProviderElementBase<Stream<State>>);
  }, name: modifierName(name, 'stream'));

  @override
  late final AutoDisposeProviderBase<Future<State>> last =
      AutoDisposeAsyncValueAsFutureProvider(this, modifierName(name, 'last'));

  @override
  AsyncValue<State> create(AutoDisposeStreamProviderRef<State> ref) {
    return _listenStream(() => _create(ref), ref);
  }

  @override
  bool recreateShouldNotify(
    AsyncValue<State> previousState,
    AsyncValue<State> newState,
  ) {
    return true;
  }

  @override
  AutoDisposeProviderElement<AsyncValue<State>> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

/// {@macro riverpod.streamprovider.family}
@sealed
class AutoDisposeStreamProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, AutoDisposeStreamProvider<State>> {
  /// {@macro riverpod.streamprovider.family}
  AutoDisposeStreamProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<Stream<State>, AutoDisposeStreamProviderRef<State>, Arg>
      _create;

  @override
  AutoDisposeStreamProvider<State> create(Arg argument) {
    return AutoDisposeStreamProvider(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
