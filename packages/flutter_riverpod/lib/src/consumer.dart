import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'internals.dart';

/// An object that allows widgets to interact with providers.
abstract class WidgetRef {
  /// The [BuildContext] of the widget associated to this [WidgetRef].
  ///
  /// This is strictly identical to the [BuildContext] passed to [ConsumerWidget.build].
  BuildContext get context;

  /// Returns the value exposed by a provider and rebuild the widget when that
  /// value changes.
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
  /// The [listen] method should exclusively be used within the `build` method
  /// of a widget:
  ///
  /// ```dart
  /// Consumer(
  ///   builder: (context, ref, child) {
  ///     ref.listen<int>(counterProvider, (prev, next) {
  ///       print('counter changed $next');
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// When used inside `build`, listeners will automatically be removed
  /// if a widget rebuilds and stops listening to a provider.
  ///
  /// For listening to a provider from outside `build`, consider using [listenManual] instead.
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
  /// other [State] lifecycles.
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
  /// Relying on [read] for optimisations is very brittle and dependent
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
  /// - possibly avoids recomputing a provider if it isn't
  ///   needed immediately.
  ///
  /// This method is useful for features like "pull to refresh" or "retry on error",
  /// to restart a specific provider.
  ///
  /// For example, a pull-to-refresh may be implemented by combining
  /// [FutureProvider] and a `RefreshIndicator`:
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
  /// If used on a provider which is not initialized, this method will have no effect.
  void invalidate(ProviderOrFamily provider);
}

/// A function that can also listen to providers
///
/// See also [Consumer]
typedef ConsumerBuilder = Widget Function(
  BuildContext context,
  WidgetRef ref,
  Widget? child,
);

/// {@template riverpod.consumer}
/// Build a widget tree while listening to providers.
///
/// [Consumer] can be used to listen to providers inside a [StatefulWidget]
/// or to rebuild as few widgets as possible when a provider updates.
///
/// As an example, consider:
///
/// ```dart
/// final helloWorldProvider = Provider((_) => 'Hello world');
/// ```
///
/// We can then use [Consumer] to listen to `helloWorldProvider` inside a
/// [StatefulWidget] like so:
///
/// ```dart
/// class Example extends StatefulWidget {
///   @override
///   _ExampleState createState() => _ExampleState();
/// }
///
/// class _ExampleState extends State<Example> {
///   @override
///   Widget build(BuildContext context) {
///     return Consumer(
///       builder: (context, ref, child) {
///         final value = ref.watch(helloWorldProvider);
///         return Text(value); // Hello world
///       },
///     );
///   }
/// }
/// ```
///
/// **Note**
/// You can watch as many providers inside [Consumer] as you want to:
///
/// ```dart
/// Consumer(
///   builder: (context, ref, child) {
///     final value = ref.watch(someProvider);
///     final another = ref.watch(anotherProvider);
///     ...
///   },
/// );
/// ```
///
/// ## Performance optimizations
///
/// If your `builder` function contains a subtree that does not depend on the
/// animation, it is more efficient to build that subtree once instead of
/// rebuilding it on every provider update.
///
/// If you pass the pre-built subtree as the `child` parameter, the
/// Consumer will pass it back to your builder function so that you
/// can incorporate it into your build.
///
/// Using this pre-built child is entirely optional, but can improve
/// performance significantly in some cases and is therefore a good practice.
///
/// This sample shows how you could use a [Consumer]
///
/// ```dart
/// final counterProvider = StateProvider((ref) => 0);
///
/// class MyHomePage extends ConsumerWidget {
///   MyHomePage({Key? key, required this.title}) : super(key: key);
///   final String title;
///
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(title)
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             Text('You have pushed the button this many times:'),
///             Consumer(
///               builder: (BuildContext context, WidgetRef ref, Widget? child) {
///                 // This builder will only get called when the counterProvider
///                 // is updated.
///                 final count = ref.watch(counterProvider);
///
///                 return Row(
///                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///                   children: <Widget>[
///                     Text('$count'),
///                     child!,
///                   ],
///                 );
///               },
///               // The child parameter is most helpful if the child is
///               // expensive to build and does not depend on the value from
///               // the notifier.
///               child: Text('Good job!'),
///             )
///           ],
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         child: Icon(Icons.plus_one),
///         onPressed: () => ref.read(counterProvider.notifier).state++,
///       ),
///     );
///   }
/// }
/// ```
///
/// See also:
///
///  * [ConsumerWidget], a base-class for widgets that wants to listen to providers.
/// {@endtemplate}
@sealed
class Consumer extends ConsumerWidget {
  /// {@macro riverpod.consumer}
  const Consumer({super.key, required ConsumerBuilder builder, Widget? child})
      : _child = child,
        _builder = builder;

  final ConsumerBuilder _builder;
  final Widget? _child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _builder(context, ref, _child);
  }
}

/// {@template riverpod.consumerwidget}
/// A [StatelessWidget] that can listen to providers.
///
/// Using [ConsumerWidget], this allows the widget tree to listen to changes on
/// provider, so that the UI automatically updates when needed.
///
/// Do not modify any state or start any http request inside [build].
///
/// As a usage example, consider:
///
/// ```dart
/// final helloWorldProvider = Provider((_) => 'Hello world');
/// ```
///
/// We can then subclass [ConsumerWidget] to listen to `helloWorldProvider` like so:
///
/// ```dart
/// class Example extends ConsumerWidget {
///   const Example({Key? key}): super(key: key);
///
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final value = ref.watch(helloWorldProvider);
///     return Text(value); // Hello world
///   }
/// }
/// ```
///
/// **Note**
/// You can watch as many providers inside [build] as you want to:
///
/// ```dart
/// @override
/// Widget build(BuildContext context, WidgetRef ref) {
///   final value = ref.watch(someProvider);
///   final another = ref.watch(anotherProvider);
///   return Text(value); // Hello world
/// }
/// ```
///
/// For reading providers inside a [StatefulWidget] or for performance
/// optimizations, see [Consumer].
/// {@endtemplate}
abstract class ConsumerWidget extends ConsumerStatefulWidget {
  /// {@macro riverpod.consumerwidget}
  const ConsumerWidget({super.key});

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree
  /// in a given [BuildContext] and when the dependencies of this widget change
  /// (e.g., an [InheritedWidget] referenced by this widget changes). This
  /// method can potentially be called in every frame and should not have any side
  /// effects beyond building a widget.
  ///
  /// The framework replaces the subtree below this widget with the widget
  /// returned by this method, either by updating the existing subtree or by
  /// removing the subtree and inflating a new subtree, depending on whether the
  /// widget returned by this method can update the root of the existing
  /// subtree, as determined by calling [Widget.canUpdate].
  ///
  /// Typically implementations return a newly created constellation of widgets
  /// that are configured with information from this widget's constructor and
  /// from the given [BuildContext].
  ///
  /// The given [BuildContext] contains information about the location in the
  /// tree at which this widget is being built. For example, the context
  /// provides the set of inherited widgets for this location in the tree. A
  /// given widget might be built with multiple different [BuildContext]
  /// arguments over time if the widget is moved around the tree or if the
  /// widget is inserted into the tree in multiple places at once.
  ///
  /// The implementation of this method must only depend on:
  ///
  /// * the fields of the widget, which themselves must not change over time,
  ///   and
  /// * any ambient state obtained from the `context` using
  ///   [BuildContext.dependOnInheritedWidgetOfExactType].
  ///
  /// If a widget's [build] method is to depend on anything else, use a
  /// [StatefulWidget] instead.
  ///
  /// See also:
  ///
  ///  * [StatelessWidget], which contains the discussion on performance considerations.
  Widget build(BuildContext context, WidgetRef ref);

  @override
  // ignore: library_private_types_in_public_api
  _ConsumerState createState() => _ConsumerState();
}

class _ConsumerState extends ConsumerState<ConsumerWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.build(context, ref);
  }
}

/// A [StatefulWidget] that can read providers.
abstract class ConsumerStatefulWidget extends StatefulWidget {
  /// A [StatefulWidget] that can read providers.
  const ConsumerStatefulWidget({super.key});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState createState();

  @override
  ConsumerStatefulElement createElement() {
    return ConsumerStatefulElement(this);
  }
}

/// A [State] that has access to a [WidgetRef] through [ref], allowing
/// it to read providers.
abstract class ConsumerState<T extends ConsumerStatefulWidget>
    extends State<T> {
  /// An object that allows widgets to interact with providers.
  late final WidgetRef ref = context as WidgetRef;
}

/// The [Element] for a [ConsumerStatefulWidget]
class ConsumerStatefulElement extends StatefulElement implements WidgetRef {
  /// The [Element] for a [ConsumerStatefulWidget]
  ConsumerStatefulElement(ConsumerStatefulWidget super.widget);

  late ProviderContainer _container = ProviderScope.containerOf(this);
  var _dependencies =
      <ProviderListenable<Object?>, ProviderSubscription<Object?>>{};
  Map<ProviderListenable<Object?>, ProviderSubscription<Object?>>?
      _oldDependencies;
  final _listeners = <ProviderSubscription<Object?>>[];
  List<_ListenManual<Object?>>? _manualListeners;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newContainer = ProviderScope.containerOf(this);
    if (_container != newContainer) {
      _container = newContainer;
      for (final dependency in _dependencies.values) {
        dependency.close();
      }
      _dependencies.clear();
    }
  }

  @override
  Widget build() {
    // TODO disallow didChangeDependencies
    try {
      _oldDependencies = _dependencies;
      for (var i = 0; i < _listeners.length; i++) {
        _listeners[i].close();
      }
      _listeners.clear();
      _dependencies = {};
      return super.build();
    } finally {
      for (final dep in _oldDependencies!.values) {
        dep.close();
      }
      _oldDependencies = null;
    }
  }

  void _assertNotDisposed() {
    if (!context.mounted) {
      throw StateError('Cannot use "ref" after the widget was disposed.');
    }
  }

  @override
  Res watch<Res>(ProviderListenable<Res> target) {
    _assertNotDisposed();
    return _dependencies.putIfAbsent(target, () {
      final oldDependency = _oldDependencies?.remove(target);

      if (oldDependency != null) {
        return oldDependency;
      }

      return _container.listen<Res>(
        target,
        (_, __) => markNeedsBuild(),
      );
    }).read() as Res;
  }

  @override
  void unmount() {
    /// Calling `super.unmount()` will call `dispose` on the state
    /// And [ListenManual] subscriptions should be closed after `dispose`
    super.unmount();

    for (final dependency in _dependencies.values) {
      dependency.close();
    }
    for (var i = 0; i < _listeners.length; i++) {
      _listeners[i].close();
    }
    final manualListeners = _manualListeners?.toList();
    if (manualListeners != null) {
      for (final listener in manualListeners) {
        listener.close();
      }
      _manualListeners = null;
    }
  }

  @override
  void listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T value) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    _assertNotDisposed();
    assert(
      debugDoingBuild,
      'ref.listen can only be used within the build method of a ConsumerWidget',
    );

    // We can't implement a fireImmediately flag because we wouldn't know
    // which listen call was preserved between widget rebuild, and we wouldn't
    // want to call the listener on every rebuild.
    final sub = _container.listen<T>(provider, listener, onError: onError);
    _listeners.add(sub);
  }

  @override
  bool exists(ProviderBase<Object?> provider) {
    _assertNotDisposed();
    return ProviderScope.containerOf(this, listen: false).exists(provider);
  }

  @override
  T read<T>(ProviderListenable<T> provider) {
    _assertNotDisposed();
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }

  @override
  State refresh<State>(Refreshable<State> provider) {
    _assertNotDisposed();
    return ProviderScope.containerOf(this, listen: false).refresh(provider);
  }

  @override
  void invalidate(ProviderOrFamily provider) {
    _assertNotDisposed();
    _container.invalidate(provider);
  }

  @override
  ProviderSubscription<T> listenManual<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    _assertNotDisposed();
    final listeners = _manualListeners ??= [];

    // Reading the container using "listen:false" to guarantee that this can
    // be used inside initState.
    final container = ProviderScope.containerOf(this, listen: false);

    final sub = _ListenManual(
      // TODO somehow pass "this" instead for the devtool's sake
      container,
      container.listen(
        provider,
        listener,
        onError: onError,
        fireImmediately: fireImmediately,
      ),
      this,
    );
    listeners.add(sub);

    return sub;
  }

  @override
  BuildContext get context => this;
}

class _ListenManual<T> extends ProviderSubscription<T> {
  _ListenManual(super.source, this._subscription, this._element);

  final ProviderSubscription<T> _subscription;
  final ConsumerStatefulElement _element;

  @override
  void close() {
    if (!closed) {
      _subscription.close();
      _element._manualListeners?.remove(this);
    }
    super.close();
  }

  @override
  T read() => _subscription.read();
}
