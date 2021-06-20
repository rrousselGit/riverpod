part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
typedef StreamProviderRef<State> = ProviderRef<AsyncValue<State>>;

/// {@macro riverpod.streamprovider}
@sealed
class StreamProvider<State> extends AlwaysAliveProviderBase<AsyncValue<State>>
    with
        ProviderOverridesMixin<AsyncValue<State>>,
        _StreamProviderMixin<State> {
  /// {@macro riverpod.streamprovider}
  StreamProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  final Create<Stream<State>, StreamProviderRef<State>> _create;

  @override
  late final AlwaysAliveProviderBase<Stream<State>> stream = Provider((ref) {
    return asyncValueToStream(this, ref as ProviderElementBase<Stream<State>>);
  }, name: modifierName(name, 'stream'));

  @override
  late final AlwaysAliveProviderBase<Future<State>> last =
      AsyncValueAsFutureProvider(this, modifierName(name, 'last'));

  @override
  AsyncValue<State> create(StreamProviderRef<State> ref) {
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
  ProviderElement<AsyncValue<State>> createElement() => ProviderElement(this);
}

/// {@template riverpod.streamprovider.family}
/// A class that allows building a [StreamProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StreamProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, StreamProvider<State>> {
  /// {@macro riverpod.streamprovider.family}
  StreamProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<Stream<State>, StreamProviderRef<State>, Arg> _create;

  @override
  StreamProvider<State> create(Arg argument) {
    return StreamProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
