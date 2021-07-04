part of '../provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [state], the value currently exposed by this providers.
abstract class ProviderRef<State> implements ProviderRefBase {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  State get state;
  set state(State newState);
}

/// {@template riverpod.provider}
/// A provider that exposes a read-only value.
///
/// ## What is a provider
///
/// Providers are the most important components of `Riverpod`. In short, you can think
/// of providers as an access point to a **shared state**.
///
/// Providers solve the following problems:
///
/// - Providers have the flexibility of global variables, without their downsides.\
///   Providers can be accessed from anywhere, while ensuring testability and scalability.
///
/// - Providers are safe to use.\
///   As opposed to most service-locator solutions, using a provider, it is not
///   possible to read a value in an uninitialized state.\
///   If we can write the code to read a state, the code will execute properly.
///   Even if the state is loaded asynchronously.
///
/// - Providers allow easily and efficiently listening to a piece of state.\
///   They can be accessed in a single line of code, and offers many way to optimize
///   your application.
///
/// ## Creating a provider
///
/// Providers come in many variants, but they all work the same way.
///
/// The most common usage is to declare them as global variables like so:
///
/// ```dart
/// final myProvider = Provider((ref) {
///   return MyValue();
/// });
/// ```
///
/// **NOTE**
/// Do not feel threatened by the fact that a provider is declared as a global.
/// While providers are globals, the variable is fully immutable.
/// This makes creating a provider no different from declaring a function or a class.
///
/// This snippet consist of three components:
///
/// - `final myProvider`, the declaration of a variable.\
///   This variable is what we will use in the future to read the state of our provider.
///   It should always be immutable.
///
/// - `Provider`, the provider that we decided to use.\
///   [Provider] is the most basic of all providers. It exposes an object that never
///   changes.\
///   We could replace [Provider] with other providers like [StreamProvider] or
///   [StateNotifierProvider], to change how the value is interacted with.
///
/// - A function that creates the shared state.\
///   That function will always receive an object called `ref` as a parameter. This object
///   allows us to read other providers or to perform some operations when the state
///   of our provider will be destroyed.
///
/// The type of the object created by the function passed to a provider depends on
/// the provider used.\
/// For example, the function of a [Provider] can create any object.
/// On the other hand, [StreamProvider]'s callback will be expected to return a [Stream].
///
/// **NOTE**:
/// You can declare as many providers as you want, without limitations.\
/// As opposed to when using `package:provider`, in `Riverpod` we can have two
/// providers expose a state of the same "type":
///
/// ```dart
/// final cityProvider = Provider((ref) => 'London');
/// final countryProvider = Provider((ref) => 'England');
/// ```
///
/// The fact that both providers creates a `String` does not cause conflicts.
/// We will be able to read both values independently from each other without issue.
///
/// **WARNING**
/// For providers to work, you need to add `ProviderScope` at the root of your
/// Flutter applications:
///
/// ```dart
/// void main() {
///   runApp(ProviderScope(child: MyApp()));
/// }
/// ```
///
/// ## Combining providers
///
/// We've previously seen how to create a simple provider. But the reality is,
/// in many situation a provider will want to read the state of another provider.
///
/// To do that, we can use the `ref` object passed to the callback of our provider,
/// and use its `watch` method.
///
/// As an example, consider the following provider:
///
/// ```dart
/// final cityProvider = Provider((ref) => 'London');
/// ```
///
/// We can now create another provider that will consume our `cityProvider`:
///
/// ```dart
/// final weatherProvider = FutureProvider((ref) async {
///   // We use `ref.watch` to watch another provider, and we pass it the provider
///   // that we want to consume. Here: cityProvider
///   final city = ref.watch(cityProvider);
///
///   // We can then use the result to do something based on the value of `cityProvider`.
///   return fetchWeather(city: city);
/// });
/// ```
///
/// That's it. We've created a provider that depends on another provider.
///
/// One interesting aspect of this code is, if `city` ever changes,
/// this will automatically call `fetchWeather` again and update the UI accordingly.
///
/// ### Creating an object that depends on a lot of providers.
///
/// Sometimes, we may want to create an object that depends on a lot of providers
/// like so:
///
/// ```dart
/// final cityProvider = Provider((ref) => 'London');
/// final countryProvider = Provider((ref) => 'England');
///
/// final weatherProvider = Provider((ref) {
///   final city = ref.watch(cityProvider);
///   final country = ref.watch(countryProvider);
///
///   return Location(city: city, country: country);
/// });
///
/// class Location {
///   Location({required this.city, required this.country});
///
///   final String city;
///   final String country;
///
///   String get label => '$city ($country)';
/// }
/// ```
///
/// This can quickly become tedious.
///
/// In that situation, it may be reasonable to pass the `ref` variable to our
/// object directly:
///
/// ```dart
/// final cityProvider = Provider((ref) => 'London');
/// final countryProvider = Provider((ref) => 'England');
///
/// final weatherProvider = Provider((ref) {
///   // Pass the `ref` object to our `Location` class.
///   // `Location` will then be able to call `ref.read` to read the providers.
///   return Location(ref);
/// });
///
/// class Location {
///   Location(this._ref);
///
///   final ProviderRefBase _ref;
///
///   String get label {
///     final city = _ref.read(cityProvider);
///     final country = _ref.read(countryProvider);
///     return '$city ($country)';
///   }
/// }
/// ```
///
/// This avoids having to implement a constructor, which makes changes on the object
/// easier.
///
/// This is fine as, as opposed to `BuildContext` from Flutter, that `ref` object
/// is completely independent from Flutter/the UI.\
/// As such the object can still be shared and tested.
///
/// ## Disposing the resources the state is destroyed
///
/// During the lifetime of an application, the state associated with a provider may
/// get destroyed.\
/// In this situation, we may want to perform a clean-up before the state destruction.
///
/// This is done by using the `ref` object that is passed to the callback of all providers.
///
/// That `ref` object expose an `onDispose` method, which can be used to listen to
/// the state destruction even to perform some task.
///
/// The following example uses `ref.onDispose` to close a `StreamController`:
///
/// ```dart
/// final example = StreamProvider.autoDispose((ref) {
///   final streamController = StreamController<int>();
///
///   ref.onDispose(() {
///     // Closes the StreamController when the state of this provider is destroyed.
///     streamController.close();
///   });
///
///   return streamController.stream;
/// });
/// ```
///
/// See also:
///
/// - [Provider.autoDispose], to automatically destroy the state of a provider
///   when that provider is no-longer listened.
/// - [Provider.family], to allow providers to create a value from external parameters.
/// {@endtemplate}
class ProviderElement<State> extends ProviderElementBase<State>
    implements ProviderRef<State> {
  /// A [ProviderElementBase] for [Provider]
  ProviderElement(ProviderBase<State> provider) : super(provider);
}

/// {@macro riverpod.provider}
@sealed
class Provider<State> extends AlwaysAliveProviderBase<State>
    with ProviderOverridesMixin<State> {
  /// {@macro riverpod.provider}
  Provider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = ProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeProviderBuilder();

  final Create<State, ProviderRef<State>> _create;

  @override
  State create(ProviderRef<State> ref) => _create(ref);

  @override
  bool recreateShouldNotify(State previousState, State newState) {
    return previousState != newState;
  }

  @override
  void setupOverride(SetupOverride setup) {
    setup(origin: this, override: this);
  }

  @override
  Override overrideWithProvider(AlwaysAliveProviderBase<State> provider) {
    return ProviderOverride((setup) {
      setup(origin: this, override: provider);
    });
  }

  @override
  Override overrideWithValue(State value) {
    return ProviderOverride((setup) {
      setup(
        origin: this,
        override: ValueProvider<State>(value),
      );
    });
  }

  @override
  ProviderElement<State> createElement() => ProviderElement(this);
}

/// {@template riverpod.provider.family}
/// A class that allows building a [Provider] from an external parameter.
/// {@endtemplate}
@sealed
class ProviderFamily<State, Arg> extends Family<State, Arg, Provider<State>> {
  /// {@macro riverpod.provider.family}
  ProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<State, ProviderRef<State>, Arg> _create;

  @override
  Provider<State> create(Arg argument) {
    return Provider(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
