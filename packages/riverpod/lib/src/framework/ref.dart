part of '../framework.dart';

/// {@template riverpod.providerrefbase}
/// An object used by providers to interact with other providers and the life-cycles
/// of the application.
///
/// See also:
///
/// - [read] and [watch], two methods that allows a provider to consume other providers.
/// - [onDispose], a method that allows performing a task when the provider is destroyed.
/// {@endtemplate}
abstract class Ref {
  /// The [ProviderContainer] that this provider is associated with.
  ProviderContainer get container;

  /// Re-create the state of a provider and return the new state.
  State refresh<State>(ProviderBase<State> provider);

  /// Adds a listener to perform an operation right before the provider is destroyed.
  ///
  /// This typically happen when a provider marked with `.autoDispose` is no-longer
  /// used, or when [ProviderContainer.dispose] is called.
  ///
  /// See also:
  ///
  /// - [Provider.autoDispose], a modifier which tell a provider that it should
  ///   destroy its state when no-longer listened.
  /// - [ProviderContainer.dispose], to destroy all providers associated with
  ///   a [ProviderContainer] at once.
  void onDispose(void Function() cb);

  /// Read the state associated with a provider, without listening to that provider.
  ///
  /// By calling [read] instead of [watch], this will not cause a provider's
  /// state to be recreated when the provider obtained changes.
  ///
  /// A typical use-case for this method is when passing it to the created
  /// object like so:
  ///
  /// ```dart
  /// final configsProvider = FutureProvider(...);
  /// final myServiceProvider = Provider((ref) {
  ///   return MyService(ref.read);
  /// });
  ///
  /// class MyService {
  ///   MyService(this.read);
  ///
  ///   final Reader read;
  ///
  ///   Future<User> fetchUser() {
  ///     // We read the current configurations, but do not care about
  ///     // rebuilding MyService when the configurations changes
  ///     final configs = read(configsProvider.future);
  ///
  ///     return dio.get(configs.host);
  ///   }
  /// }
  /// ```
  ///
  /// By passing [read] to an object, this allows our object to read other providers.
  /// But we do not want to re-create our object if any of the provider
  /// obtained changes. We only want to read their current value without doing
  /// anything else.
  ///
  /// If possible, avoid using [read] and prefer [watch], which is generally
  /// safer to use.
  T read<T>(ProviderBase<T> provider);

  /// Obtains the state of a provider and cause the state to be re-evaluated
  /// when that provider emits a new value.
  ///
  /// Using [watch] allows supporting the scenario where we want to re-create
  /// our state when one of the object we are listening to changed.
  ///
  /// This method should be your go-to way to make a provider read another
  /// provider – even if the value exposed by that other provider never changes.
  ///
  /// ## Use-case example: Sorting a todo-list
  ///
  /// Consider a todo-list application. We may want to implement a sort feature,
  /// to see the uncompleted todos first.\
  /// We will want to create a sorted list of todos based on the
  /// combination of the unsorted list and a sort method (ascendant, descendant, ...),
  /// both of which may change over time.
  ///
  /// In this situation, what we do not want to do is to sort our list
  /// directly inside the `build` method of our UI, as sorting a list can be
  /// expensive.
  /// But maintaining a cache manually is difficult and error prone.
  ///
  /// To solve this problem, we could create a separate [Provider] that will
  /// expose the sorted list, and use [watch] to automatically re-evaluate
  /// the list **only** when needed.
  ///
  /// In code, this may look like:
  ///
  /// ```dart
  /// final sortProvider = StateProvider((_) => Sort.byName);
  /// final unsortedTodosProvider = StateProvider((_) => <Todo>[]);
  ///
  /// final sortedTodosProvider = Provider((ref) {
  ///   // listen to both the sort enum and the unfiltered list of todos
  ///   final sort = ref.watch(sortProvider);
  ///   final todos = ref.watch(unsortedTodosProvider);
  ///
  ///   // Creates a new sorted list from the combination of the unfiltered
  ///   // list and the filter type.
  ///   return [...todos].sort((a, b) { ... });
  /// });
  /// ```
  ///
  /// In this code, by using [Provider] + [watch]:
  ///
  /// - if either `sortProvider` or `unsortedTodosProvider` changes, then
  ///   `sortedTodosProvider` will automatically be recomputed.
  /// - if multiple widgets depends on `sortedTodosProvider` the list will be
  ///   sorted only once.
  /// - if nothing is listening to `sortedTodosProvider`, then no sort is performed.
  T watch<T>(AlwaysAliveProviderListenable<T> provider);

  /// Listen to a provider and call `listener` whenever its value changes.
  ///
  /// Listeners will automatically be removed when the provider rebuilds (such
  /// as when a provider listeneed with [watch] changes).
  ///
  /// Returns a function that allows cancelling the subscription early.
  ///
  /// - `fireImmediately` can be optionally passed to tell Riverpod to immediately
  ///    call the listener with the current value.
  ///    Defaults to false.
  // TODO update ProviderContainer.listen to match the return value
  RemoveListener listen<T>(
    AlwaysAliveProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    bool fireImmediately,
    void Function(Object error, StackTrace stackTrace)? onError,
  });
}
