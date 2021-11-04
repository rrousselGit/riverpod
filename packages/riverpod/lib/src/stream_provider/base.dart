part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
abstract class StreamProviderRef<State> implements Ref {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  ///
  /// Will throw if the provider threw during creation.
  AsyncValue<State> get state;
  set state(AsyncValue<State> newState);
}

/// {@macro riverpod.streamprovider}
@sealed
class StreamProvider<State> extends AlwaysAliveProviderBase<AsyncValue<State>>
    with
        OverrideWithValueMixin<AsyncValue<State>>,
        OverrideWithProviderMixin<AsyncValue<State>,
            AlwaysAliveProviderBase<AsyncValue<State>>> {
  /// {@macro riverpod.streamprovider}
  StreamProvider(
    this._create, {
    String? name,
    this.dependencies,
    Family? from,
    Object? argument,
  }) : super(name: name, from: from, argument: argument);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  @override
  ProviderBase<AsyncValue<State>> get originProvider => this;

  final Create<Stream<State>, StreamProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  /// {@template riverpod.streamprovider.stream}
  /// Exposes the [Stream] created by a [StreamProvider].
  ///
  /// The stream obtained is not strictly identical to the stream created.
  /// Instead, this stream is always a broadcast stream.
  ///
  /// The stream obtained may change over time, if the [StreamProvider] is
  /// re-evaluated, such as when it is using [Ref.watch] and the
  /// provider listened changes, or on [ProviderContainer.refresh].
  ///
  /// If the [StreamProvider] was overridden using `overrideWithValue`,
  /// a stream will be generated and manipulated based on the [AsyncValue] used.
  /// {@endtemplate}
  late final AlwaysAliveProviderBase<Stream<State>> stream =
      AsyncValueAsStreamProvider(this, from: from, argument: argument);

  /// {@template riverpod.streamprovider.future}
  /// Exposes a [Future] which resolves with the last value or error emitted.
  ///
  /// This can be useful for scenarios where we want to read the current value
  /// exposed by a [StreamProvider], but also handle the scenario were no
  /// value were emitted yet:
  ///
  /// ```dart
  /// final configsProvider = StreamProvider<Configuration>((ref) async* {
  ///   // somehow emit a Configuration instance
  /// });
  ///
  /// final productsProvider = FutureProvider<Products>((ref) async {
  ///   // If a "Configuration" was emitted, retrieve it.
  ///   // Otherwise, wait for a Configuration to be emitted.
  ///   final configs = await ref.watch(configsProvider.last);
  ///
  ///   final response = await httpClient.get('${configs.host}/products');
  ///   return Products.fromJson(response.data);
  /// });
  /// ```
  ///
  /// ## Why not use [StreamProvider.stream.first] instead?
  ///
  /// If you are familiar with streams, you may wonder why not use [Stream.first]
  /// instead:
  ///
  /// ```dart
  /// final configsProvider = StreamProvider<Configuration>((ref) {...});
  ///
  /// final productsProvider = FutureProvider<Products>((ref) async {
  ///   final configs = await ref.watch(configsProvider.stream).first;
  ///   ...
  /// }
  /// ```
  ///
  /// The problem with this code is, unless your [StreamProvider] is creating
  /// a `BehaviorSubject` from `package:rxdart`, you have a bug.
  ///
  /// By default, if we call [Stream.first] **after** the first value was emitted,
  /// then the [Future] created will not obtain that first value but instead
  /// wait for a second one – which may never come.
  ///
  /// The following code demonstrate this problem:
  ///
  /// ```dart
  /// final exampleProvider = StreamProvider<int>((ref) async* {
  ///   yield 42;
  /// });
  ///
  /// final anotherProvider = FutureProvider<void>((ref) async {
  ///   print(await ref.watch(exampleProvider.stream).first);
  ///   // The code will block here and wait forever
  ///   print(await ref.watch(exampleProvider.stream).first);
  ///   print('this code is never reached');
  /// });
  ///
  /// void main() async {
  ///   final container = ProviderContainer();
  ///   await container.read(anotherProvider.future);
  ///   // never reached
  ///   print('done');
  /// }
  /// ```
  ///
  /// This snippet will print `42` once, then wait forever.
  ///
  /// On the other hand, if we used [StreamProvider.future], our code would
  /// correctly execute:
  ///
  /// ```dart
  /// final exampleProvider = StreamProvider<int>((ref) async* {
  ///   yield 42;
  /// });
  ///
  /// final anotherProvider = FutureProvider<void>((ref) async {
  ///   print(await ref.watch(exampleProvider.future));
  ///   print(await ref.watch(exampleProvider.future));
  ///   print('completed');
  /// });
  ///
  /// void main() async {
  ///   final container = ProviderContainer();
  ///   await container.read(anotherProvider.future);
  ///   print('done');
  /// }
  /// ```
  ///
  /// with this modification, our code will now print:
  ///
  /// ```
  /// 42
  /// 42
  /// completed
  /// done
  /// ```
  ///
  /// which is the expected behavior.
  /// {@endtemplate}
  late final AlwaysAliveProviderBase<Future<State>> future =
      AsyncValueAsFutureProvider(this, from: from, argument: argument);

  /// {@template riverpod.streamprovider.future}
  @Deprecated('use `future` instead')
  AlwaysAliveProviderBase<Future<State>> get last => future;

  @override
  AsyncValue<State> create(covariant StreamProviderElement<State> ref) {
    return ref._listenStream(() => _create(ref));
  }

  @override
  bool updateShouldNotify(
    AsyncValue<State> previousState,
    AsyncValue<State> newState,
  ) {
    final wasLoading = previousState is AsyncLoading;
    final isLoading = newState is AsyncLoading;

    if (wasLoading || isLoading) return wasLoading != isLoading;

    return true;
  }

  @override
  StreamProviderElement<State> createElement() => StreamProviderElement(this);
}

/// The Element of a [StreamProvider]
class StreamProviderElement<State>
    extends ProviderElementBase<AsyncValue<State>>
    with _StreamProviderElementMixin<State>
    implements StreamProviderRef<State> {
  /// The Element of a [StreamProvider]
  StreamProviderElement(StreamProvider<State> provider) : super(provider);

  @override
  AsyncValue<State> get state => requireState;

  @override
  set state(AsyncValue<State> newState) => setState(newState);
}

/// {@template riverpod.streamprovider.family}
/// A class that allows building a [StreamProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StreamProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, StreamProvider<State>> {
  /// {@macro riverpod.streamprovider.family}
  StreamProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Stream<State>, StreamProviderRef<State>, Arg> _create;

  @override
  StreamProvider<State> create(Arg argument) {
    return StreamProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
      from: this,
      argument: argument,
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider, override: provider);
  }

  /// {@macro riverpod.overridewithprovider}
  Override overrideWithProvider(
    AlwaysAliveProviderBase<AsyncValue<State>> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      final provider = call(arg);
      setup(origin: provider, override: override(arg));
    });
  }
}
