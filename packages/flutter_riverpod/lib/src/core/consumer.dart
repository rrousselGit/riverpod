part of '../core.dart';

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

/// {@template riverpod.consumer_widget}
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
  /// {@macro riverpod.consumer_widget}
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

    final sub = _container.listen<T>(provider, listener, onError: onError);
    _listeners.add(sub);
  }

  @override
  bool exists(AnyProvider<Object?> provider) {
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
  void invalidate(AnyProviderOrFamily provider) {
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
