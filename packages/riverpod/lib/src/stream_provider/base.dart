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
  late final AlwaysAliveProviderBase<Stream<State>> stream =
      AsyncValueAsStreamProvider(this, modifierName(name, 'stream'));

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
  Override overrideWithProvider(
    AlwaysAliveProviderBase<AsyncValue<State>> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: this, override: provider);
      setup(origin: stream, override: stream);
      setup(origin: last, override: last);
    });
  }

  @override
  Override overrideWithValue(AsyncValue<State> value) {
    return ProviderOverride((setup) {
      setup(origin: this, override: ValueProvider<AsyncValue<State>>(value));
      setup(origin: stream, override: stream);
      setup(origin: last, override: last);
    });
  }

  @override
  void setupOverride(SetupOverride setup) {
    setup(origin: this, override: this);
    setup(origin: stream, override: stream);
    setup(origin: last, override: last);
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
    final provider = StreamProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
    );

    registerProvider(provider.stream, argument);
    registerProvider(provider.last, argument);

    return provider;
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider, override: provider);
    setup(origin: provider.stream, override: provider.stream);
    setup(origin: provider.last, override: provider.last);
  }

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    ProviderBase<AsyncValue<State>> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      final provider = call(arg);
      setup(origin: provider, override: override(arg));
      setup(origin: provider.stream, override: provider.stream);
      setup(origin: provider.last, override: provider.last);
    });
  }
}
