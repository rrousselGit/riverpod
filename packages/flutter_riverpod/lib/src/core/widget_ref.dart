part of '../core.dart';

/// {@template flutter_riverpod.widget_ref}
/// An object that allows widgets to interact with providers.
///
/// [WidgetRef]s are typically obtained by using [ConsumerWidget] or its variants:
///
/// ```dart
/// class Example extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     // We now have a "ref"
///   }
/// }
/// ```
///
/// Once we have a [WidgetRef], we can use its various methods to interact with
/// providers.
/// The most common use-case is to use [WidgetRef.watch] inside the `build` method of our
/// widgets. This will enable our UI to update whenever the state of a provider
/// changes:
///
/// ```dart
/// @override
/// Widget build(BuildContext context, WidgetRef ref) {
///   final count = ref.watch(counterProvider);
///   // The text will automatically update whenever `counterProvider` emits a new value
///   return Text('$count');
/// }
/// ```
///
/// **Note**:
/// Using a [WidgetRef] is equivalent to writing UI logic.
/// As such, [WidgetRef]s should not leave the widget layer. If you need to
/// interact with providers outside of the widget layer, consider using
/// a [Ref] instead.
/// {@endtemplate}
/// {@category core}
abstract final class WidgetRef {
  /// The [BuildContext] of the widget associated to this [WidgetRef].
  ///
  /// This is strictly identical to the [BuildContext] passed to [ConsumerWidget.build].
  BuildContext get context;

  /// Returns the value exposed by a provider and rebuild the widget when that
  /// value changes.
  ///
  /// This method should only be used at the "root" of the `build` method of a widget.
  ///
  /// **Good**: Use [watch] inside the `build` method.
  /// ```dart
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     // Correct, we are inside the build method and at its root.
  ///     final count = ref.watch(counterProvider);
  ///   }
  /// }
  /// ```
  /// **Good**: It is accepted to use [watch] at the root of "builders" too.
  /// ```dart
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     return ListView.builder(
  ///       itemBuilder: (context) {
  ///          // This is accepted, as we are at the root of a "builder"
  ///          final count = ref.watch(counterProvider);
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// **Bad**: Don't use [watch] outside of the `build` method.
  /// ```dart
  /// class Example extends ConsumerStatefulWidget {
  ///   @override
  ///   ExampleState createState() => ExampleState();
  /// }
  ///
  /// class ExampleState extends ConsumerState<Example> {
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     // Incorrect, we are not inside the build method.
  ///     final count = ref.watch(counterProvider);
  ///   }
  /// }
  /// ```
  ///
  /// **Bad**: Don't use [watch] inside event handles withing `build` method.
  /// ```dart
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     return ElevatedButton(
  ///       onTap: () {
  ///         // Incorrect, we are inside the build method, but neither at its
  ///         // root, nor inside a "builder".
  ///         final count = ref.watch(counterProvider);
  ///       }
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// - [ProviderListenable.select], which allows a widget to filter rebuilds by
  ///   observing only the selected properties.
  /// - [listen], to react to changes on a provider, such as for showing modals.
  T watch<T>(ProviderListenable<T> provider);

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
  bool exists(ProviderBase<Object?> provider);

  /// Listen to a provider and call `listener` whenever its value changes,
  /// without having to take care of removing the listener.
  ///
  /// The [listen] method should exclusively be used at the root of the `build`:
  ///
  /// **Good**: Use [listen] inside the `build` method.
  /// ```dart
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     // Correct, we are inside the build method and at its root.
  ///     ref.listen(counterProvider, (prev, next) {});
  ///   }
  /// }
  /// ```
  ///
  /// **Bad**: Do not use [listen] inside builders.
  /// ```dart
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     return ListView.builder(
  ///       itemBuilder: (context) {
  ///          // This is accepted, as we are at the root of a "builder"
  ///          ref.listen(counterProvider, (prev, next) {});
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// **Bad**: Don't use [listen] outside of the `build` method.
  /// ```dart
  /// class Example extends ConsumerStatefulWidget {
  ///   @override
  ///   ExampleState createState() => ExampleState();
  /// }
  ///
  /// class ExampleState extends ConsumerState<Example> {
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     // Incorrect, we are not inside the build method.
  ///     ref.listen(counterProvider, (prev, next) {});
  ///   }
  /// }
  /// ```
  ///
  /// **Bad**: Don't use [listen] inside event handles withing `build` method.
  /// ```dart
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     return ElevatedButton(
  ///       onTap: () {
  ///         // Incorrect, we are inside the build method, but neither at its
  ///         // root, nor inside a "builder".
  ///         ref.listen(counterProvider, (prev, next) {});
  ///       }
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// **Note**:
  /// Listeners will automatically be removed if a widget rebuilds and stops
  /// listening to a provider.
  ///
  /// See also:
  /// - [listenManual], for listening to a provider from outside `build`.
  /// - [watch], to listen to providers in a declarative manner.
  /// - [read], to read a provider without listening to it.
  ///
  /// This is useful for showing modals or other imperative logic.
  void listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });

  /// Listen to a provider and call `listener` whenever its value changes.
  ///
  /// As opposed to [listen], [listenManual] is not safe to use within the `build`
  /// method of a widget.
  /// Instead, [listenManual] is designed to be used inside [State.initState] or
  /// other [State] life-cycles.
  ///
  /// [listenManual] returns a [ProviderSubscription] which can be used to stop
  /// listening to the provider, or to read the current value exposed by
  /// the provider.
  ///
  /// It is not necessary to call [ProviderSubscription.close] inside [State.dispose].
  /// When the widget that calls [listenManual] is disposed, the subscription
  /// will be disposed automatically.
  ProviderSubscription<T> listenManual<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately,
  });

  /// Reads a provider without listening to it.
  ///
  /// **AVOID** calling [read] inside build if the value is used only for events:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // counter is used only for the onPressed of RaisedButton
  ///   final counter = ref.read(counterProvider);
  ///
  ///   return RaisedButton(
  ///     onPressed: () => counter.increment(),
  ///   );
  /// }
  /// ```
  ///
  /// While this code is not bugged in itself, this is an anti-pattern.
  /// It could easily lead to bugs in the future after refactoring the widget
  /// to use `counter` for other things, but forget to change [read] into [Consumer]/`ref.watch(`.
  ///
  /// **CONSIDER** calling [read] inside event handlers:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return RaisedButton(
  ///     onPressed: () {
  ///       // as performant as the previous solution, but resilient to refactoring
  ///       ref.read(counterProvider).increment(),
  ///     },
  ///   );
  /// }
  /// ```
  ///
  /// This has the same efficiency as the previous anti-pattern, but does not
  /// suffer from the drawback of being brittle.
  ///
  /// **AVOID** using [read] for creating widgets with a value that never changes
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // using read because we only use a value that never changes.
  ///   final model = ref.read(modelProvider);
  ///
  ///   return Text('${model.valueThatNeverChanges}');
  /// }
  /// ```
  ///
  /// While the idea of not rebuilding the widget if unnecessary is good,
  /// this should not be done with [read].
  /// Relying on [read] for optimizations is very brittle and dependent
  /// on an implementation detail.
  ///
  /// **CONSIDER** using [Provider] or `select` for filtering unwanted rebuilds:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // Using select to listen only to the value that used
  ///   final valueThatNeverChanges = ref.watch(modelProvider.select((model) {
  ///     return model.valueThatNeverChanges;
  ///   }));
  ///
  ///   return Text('$valueThatNeverChanges');
  /// }
  /// ```
  ///
  /// While more verbose than [read], using [Provider]/`select` is a lot safer.
  /// It does not rely on implementation details on `Model`, and it makes
  /// impossible to have a bug where our UI does not refresh.
  T read<T>(ProviderListenable<T> provider);

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
  /// - possibly avoiding recomputing a provider if it isn't needed immediately.
  ///
  /// This method is useful for features like "pull to refresh" or "retry on error",
  /// to restart a specific provider.
  ///
  /// For example, a pull-to-refresh may be implemented by combining
  /// [FutureProvider] and a [RefreshIndicator]:
  ///
  /// ```dart
  /// final productsProvider = FutureProvider((ref) async {
  ///   final response = await httpClient.get('https://host.com/products');
  ///   return Products.fromJson(response.data);
  /// });
  ///
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     final Products products = ref.watch(productsProvider);
  ///
  ///     return RefreshIndicator(
  ///       onRefresh: () => ref.refresh(productsProvider.future),
  ///       child: ListView(
  ///         children: [
  ///           for (final product in products.items) ProductItem(product: product),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  @useResult
  State refresh<State>(Refreshable<State> provider);

  /// Invalidates the state of the provider, causing it to refresh.
  ///
  /// As opposed to [refresh], the refresh is not immediate and is instead
  /// delayed to the next read or next frame.
  ///
  /// Calling [invalidate] multiple times will refresh the provider only
  /// once.
  ///
  /// Calling [invalidate] will cause the provider to be disposed immediately.
  ///
  /// - [asReload] (false by default) can be optionally passed to tell
  ///   Riverpod to clear the state before refreshing it.
  ///   This is only useful for asynchronous providers, as by default,
  ///   [AsyncValue] keeps a reference on state during loading states.
  ///   Using [asReload] will disable this behavior and count as a
  ///   "hard refresh".
  ///
  /// If used on a provider which is not initialized, this method will have no effect.
  void invalidate(
    ProviderOrFamily provider, {
    bool asReload = false,
  });
}
