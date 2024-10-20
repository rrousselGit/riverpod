part of '../framework.dart';

/// {@template riverpod.provider_ref_base}
/// An object used by providers to interact with other providers and the life-cycles
/// of the application.
///
/// See also:
///
/// - [read] and [watch], two methods that allow a provider to consume other providers.
/// - [onDispose], a method that allows performing a task when the provider is destroyed.
/// {@endtemplate}
@optionalTypeArgs
abstract class Ref<
    @Deprecated('Will be removed in 3.0') State extends Object?> {
  /// The [ProviderContainer] that this provider is associated with.
  ProviderContainer get container;

  /// {@template riverpod.refresh}
  /// Forces a provider to re-evaluate its state immediately, and return the created value.
  ///
  /// Writing:
  ///
  /// ```dart
  /// final newValue = ref.refresh(provider);
  /// ```
  ///
  /// is strictly identical to doing:
  ///
  /// ```dart
  /// ref.invalidate(provider);
  /// final newValue = ref.read(provider);
  /// ```
  ///
  /// If you do not care about the return value of [refresh], use [invalidate] instead.
  /// Doing so has the benefit of:
  /// - making the invalidation logic more resilient by avoiding multiple
  ///   refreshes at once.
  /// - possibly avoids recomputing a provider if it isn't
  ///   needed immediately.
  ///
  /// This method is useful for features like "pull to refresh" or "retry on error",
  /// to restart a specific provider.
  /// {@endtemplate}
  @useResult
  T refresh<T>(Refreshable<T> provider);

  /// {@template riverpod.invalidate}
  /// Invalidates the state of the provider, destroying the state immediately
  /// and causing the provider to rebuild at some point in the future.
  ///
  /// As opposed to [refresh], the rebuild is not immediate and is instead
  /// delayed by an undefined amount of time.
  /// Typically, the rebuild happens at the next tick of the event loop.
  /// But if a provider is not listened to, the rebuild may be delayed until
  /// the provider is listened to again.
  ///
  /// Calling [invalidate] multiple times will cause a single recomputation of the state.
  ///
  /// If used on a provider which is not initialized or disposed,
  /// this method will have no effect.
  /// {@endtemplate}
  void invalidate(ProviderOrFamily provider);

  /// Notify dependents that this provider has changed.
  ///
  /// This is typically used for mutable state, such as to do:
  ///
  /// ```dart
  /// class TodoList extends Notifier<List<Todo>> {
  ///   @override
  ///   List<Todo>> build() => [];
  ///
  ///   void addTodo(Todo todo) {
  ///     state.add(todo);
  ///     ref.notifyListeners();
  ///   }
  /// }
  /// ```
  void notifyListeners();

  /// Listens to changes on the value exposed by this provider.
  ///
  /// The listener will be called immediately after the provider completes building.
  ///
  /// As opposed to [listen], the listener will be called even if
  /// [ProviderElementBase.updateShouldNotify] returns false, meaning that the previous
  /// and new value can potentially be identical.
  @Deprecated('Will be removed in 3.0. Use Notifier.listenSelf instead')
  void listenSelf(
    void Function(State? previous, State next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });

  /// Invalidates the state of the provider, causing it to refresh.
  ///
  /// The refresh is not immediate and is instead delayed to the next read
  /// or next frame.
  ///
  /// Calling [invalidateSelf] multiple times will refresh the provider only
  /// once.
  ///
  /// Calling [invalidateSelf] will cause the provider to be disposed immediately.
  void invalidateSelf();

  /// A life-cycle for whenever a new listener is added to the provider.
  ///
  /// See also:
  /// - [onRemoveListener], for when a listener is removed
  void onAddListener(void Function() cb);

  /// A life-cycle for whenever a listener is removed from the provider.
  ///
  /// See also:
  /// - [onAddListener], for when a listener is added
  void onRemoveListener(void Function() cb);

  /// A life-cycle for when a provider is listened again after it was paused
  /// (and [onCancel] was triggered).
  ///
  /// See also:
  /// - [keepAlive], which can be combined with [onCancel] for
  ///   advanced manipulation on when the provider should get disposed.
  /// - [Provider.autoDispose], a modifier which tell a provider that it should
  ///   destroy its state when no longer listened to.
  /// - [onDispose], a life-cycle for when a provider is disposed.
  /// - [onCancel], a life-cycle for when all listeners of a provider are removed.
  void onResume(void Function() cb);

  /// Add a listener to perform an operation when the last listener of the provider
  /// is removed.
  ///
  /// This typically means that the provider will be paused (or disposed if
  /// using [Provider.autoDispose]) unless a new listener is added.
  ///
  /// When the callback is invoked, there is no guarantee that the provider
  /// _will_ get paused/dispose. It is possible that after the last listener
  /// is removed, a new listener is immediately added.
  ///
  /// See also:
  /// - [keepAlive], which can be combined with [onCancel] for
  ///   advanced manipulation on when the provider should get disposed.
  /// - [Provider.autoDispose], a modifier which tell a provider that it should
  ///   destroy its state when no longer listened to.
  /// - [onDispose], a life-cycle for when a provider is disposed.
  /// - [onResume], a life-cycle for when the provider is listened to again.
  void onCancel(void Function() cb);

  /// Adds a listener to perform an operation right before the provider is destroyed.
  ///
  /// This includes:
  /// - when the provider will rebuild (such as when using [watch] or [refresh]).
  /// - when an `autoDispose` provider is no longer used
  /// - when the associated [ProviderContainer]/`ProviderScope` is disposed`.
  ///
  /// **Prefer** having multiple [onDispose], for every disposable object created,
  /// instead of a single large [onDispose]:
  ///
  /// Good:
  /// ```dart
  /// final disposable1 = Disposable(...);
  /// ref.onDispose(disposable1.dispose);
  ///
  /// final disposable2 = Disposable(...);
  /// ref.onDispose(disposable2.dispose);
  /// ```
  ///
  /// Bad:
  /// ```dart
  /// final disposable1 = Disposable(...);
  /// final disposable2 = Disposable(...);
  ///
  /// ref.onDispose(() {
  ///   disposable1.dispose();
  ///   disposable2.dispose();
  /// });
  /// ```
  ///
  /// This is preferable for multiple reasons:
  /// - It is easier for readers to know if a "dispose" is missing for a given
  ///   object. That is because the `dispose` call is directly next to the
  ///   object creation.
  /// - It prevents memory leaks in cases of an exception.
  ///   If an exception happens inside a `dispose()` call, or
  ///   if an exception happens before [onDispose] is called, then
  ///   some of your objects may not be disposed.
  ///
  /// See also:
  ///
  /// - [Provider.autoDispose], a modifier which tell a provider that it should
  ///   destroy its state when no longer listened to.
  /// - [ProviderContainer.dispose], to destroy all providers associated with
  ///   a [ProviderContainer] at once.
  /// - [onCancel], a life-cycle for when all listeners of a provider are removed.
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
  /// final myServiceProvider = Provider(MyService.new);
  ///
  /// class MyService {
  ///   MyService(this.ref);
  ///
  ///   final Ref ref;
  ///
  ///   Future<User> fetchUser() {
  ///     // We read the current configurations, but do not care about
  ///     // rebuilding MyService when the configurations changes
  ///     final configs = ref.read(configsProvider.future);
  ///
  ///     return dio.get(configs.host);
  ///   }
  /// }
  /// ```
  ///
  /// By passing [Ref] to an object, this allows our object to read other providers.
  /// But we do not want to re-create our object if any of the provider
  /// obtained changes. We only want to read their current value without doing
  /// anything else.
  ///
  /// If possible, avoid using [read] and prefer [watch], which is generally
  /// safer to use.
  T read<T>(ProviderListenable<T> provider);

  /// {@template riverpod.exists}
  /// Determines whether a provider is initialized or not.
  ///
  /// Writing logic that conditionally depends on the existence of a provider
  /// is generally unsafe and should be avoided.
  /// The problem is that once the provider gets initialized, logic that
  /// depends on the existence or not of a provider won't be rerun; possibly
  /// causing your state to get out of date.
  ///
  /// But it can be useful in some cases, such as to avoid re-fetching an
  /// object if a different network request already obtained it:
  ///
  /// ```dart
  /// final fetchItemList = FutureProvider<List<Item>>(...);
  ///
  /// final fetchItem = FutureProvider.autoDispose.family<Item, String>((ref, id) async {
  ///   if (ref.exists(fetchItemList)) {
  ///     // If `fetchItemList` is initialized, we look into its state
  ///     // and return the already obtained item.
  ///     final itemFromItemList = await ref.watch(
  ///       fetchItemList.selectAsync((items) => items.firstWhereOrNull((item) => item.id == id)),
  ///     );
  ///     if (itemFromItemList != null) return itemFromItemList;
  ///   }
  ///
  ///   // If `fetchItemList` is not initialized, perform a network request for
  ///   // "id" separately
  ///
  ///   final json = await http.get('api/items/$id');
  ///   return Item.fromJson(json);
  /// });
  /// ```
  /// {@endtemplate}
  bool exists(ProviderBase<Object?> provider);

  /// Obtains the state of a provider and causes the state to be re-evaluated
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
  T watch<T>(ProviderListenable<T> provider);

  /// Requests for the state of a provider to not be disposed when all the
  /// listeners of the provider are removed.
  ///
  /// Returns an object which allows cancelling this operation, therefore
  /// allowing the provider to dispose itself when all listeners are removed.
  ///
  /// If [keepAlive] is invoked multiple times, all [KeepAliveLink] will have
  /// to be closed for the provider to dispose itself when all listeners are removed.
  ///
  /// **Note**:
  /// This is only useful if your provider is using "auto dispose".
  /// If your provider is not using "auto dispose", then this method has no effect.
  ///
  /// **Note**:
  /// A provider that is kept alive may still be paused.
  /// If a provider is not listened, regardless of whether it is kept alive or not,
  /// the provider won't rebuild when using [watch] until it is listened to again.
  KeepAliveLink keepAlive();

  /// {@template riverpod.listen}
  /// Listen to a provider and call [listener] whenever its value changes.
  ///
  /// Listeners will automatically be removed when the provider rebuilds (such
  /// as when a provider listened with [watch] changes).
  ///
  /// Returns an object that allows cancelling the subscription early.
  ///
  ///
  /// [fireImmediately] (false by default) can be optionally passed to tell
  /// Riverpod to immediately call the listener with the current value.
  ///
  /// [onError] can be specified to listen to uncaught errors in the provider.\
  /// **Note:**\
  /// [onError] will _not_ be triggered if the provider catches the exception
  /// and emit a valid value out of it. As such, if a
  /// [FutureProvider]/[StreamProvider] fail, [onError] will not be called.
  /// Instead the listener will receive an [AsyncError].
  /// {@endtemplate}
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately,
  });
}

/// A [Ref] for providers that are automatically destroyed when
/// no longer used.
///
/// The difference with [Ref] is that it has an extra
/// [keepAlive] function to help determine if the state can be destroyed
///  or not.
@Deprecated('Will be removed in 3.0. Use Ref instead')
abstract class AutoDisposeRef<State> extends Ref<State> {
  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `false`,
  /// may destroy the provider state if it currently has no listeners.
  ///
  /// Defaults to `false`.
  @Deprecated('use keepAlive() instead')
  bool get maintainState;

  @Deprecated('use keepAlive() instead')
  set maintainState(bool value);
}
