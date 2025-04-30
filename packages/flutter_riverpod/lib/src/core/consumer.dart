part of '../core.dart';

/// A function that can also listen to providers
///
/// See also [Consumer]
@internal
typedef ConsumerBuilder = Widget Function(
  BuildContext context,
  WidgetRef ref,
  Widget? child,
);

/// {@template riverpod.consumer}
/// Build a widget tree while listening to providers.
///
/// [Consumer]'s main use-case is for reducing the number of rebuilt widgets.
/// when a provider changes.
///
/// As an example, consider:
///
/// ```dart
/// @riverpod
/// Future<User> fetchUser(Ref ref) async {
///   // ...
/// }
/// ```
///
/// Normally, we would use a [ConsumerWidget] as followed:
///
/// ```dart
/// class Example extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     return Scaffold(
///      appBar: AppBar(title: Text('User')),
///      body: switch (ref.watch(userProvider) {
///        AsyncValue(:final value?) => Text(value.name),
///        AsyncValue(hasError: true) => Text('Error'),
///        _ => CircularProgressIndicator(),
///      },
///   }
/// }
/// ```
///
/// However, this would rebuild the entire `Scaffold` when the user changes.
/// If we are looking to reduce this, have two options:
/// - Extract the `body` into a separate [ConsumerWidget]. Then only the `body` will rebuild.
///   This is the recommended approach, but is a bit more verbose.
/// - Use [Consumer] to only rebuild the `body` when the user changes.
///   This is less recommended, but avoids creating a new widget.
///
/// Using [Consumer], the resulting code would look like:
/// ```dart
/// class Example extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///      appBar: AppBar(title: Text('User')),
///      body: Consumer(
///        builder: (context, ref, child) {
///          return switch (ref.watch(userProvider) {
///            AsyncValue(:final value?) => Text(value.name),
///            AsyncValue(hasError: true) => Text('Error'),
///            _ => CircularProgressIndicator(),
///          };
///        }),
///      );
///   }
/// }
/// ```
///
/// ## Performance considerations
///
/// To optimize performance by avoiding unnecessary network requests and
/// pausing unused streams, [Consumer] will temporarily stop listening to
/// providers when the widget stops being visible.
///
/// This is determined using [Visibility.of], and will invoke
/// [ProviderSubscription.pause] on all currently active subscriptions.
///
/// See also:
///
/// - [ConsumerWidget], a base-class for widgets that wants to listen to providers.
/// - [child], a way to optimize the widget tree by passing a child widget that
///   won't rebuild when the provider changes.
/// {@endtemplate}
/// {@category Core}
final class Consumer extends ConsumerWidget {
  /// {@macro riverpod.consumer}
  const Consumer({super.key, required this.builder, this.child});

  /// The builder that will be called when the provider is updated.
  ///
  /// The `child` parameter will be the same as [child] if specified, or null otherwise.
  ///
  /// **Note**
  /// You can watch as many providers inside [Consumer] as you want to:
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
  /// See also [child].
  final ConsumerBuilder builder;

  /// The [child] parameter is an optional parameter for the sole purpose of
  /// further performance optimizations.
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
  /// final counterProvider = NotifierProvider<Counter, int>(Counter.new);
  /// class Counter extends Notifier<int> {
  ///   @override
  ///   int build() => 0;
  ///
  ///   void increment() => state++;
  /// }
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
  ///         onPressed: () => ref.read(counterProvider.notifier).increment(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return builder(context, ref, child);
  }
}

/// {@template riverpod.consumer_widget}
/// The equivalent of a [StatelessWidget] that can listen to providers.
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
/// See also:
/// - [ConsumerStatefulWidget], for a [StatefulWidget] variant.
/// - [Consumer], to help reducing the number of rebuilt widgets without making
///   a new widget.
/// {@endtemplate}
/// {@category Core}
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
  Widget build(BuildContext context) => widget.build(context, ref);
}

/// {@template riverpod.consumer_stateful_widget}
/// A [StatefulWidget] that has a [State] capable of reading providers.
///
/// This is used exactly like a [StatefulWidget], but with a [State] that must
/// subclass [ConsumerState] :
///
/// ```dart
/// class MyConsumer extends ConsumerStatefulWidget {
///  const MyConsumer({Key? key}): super(key: key);
///
///   @override
///   ConsumerState<MyConsumer> createState() => _MyConsumerState();
/// }
///
/// class _MyConsumerState extends ConsumerState<MyConsumer> {
///   @override
///   void initState() {
///     // All State life-cycles can be used
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     // "ref" is a property of ConsumerState and can be used to read providers
///     ref.watch(someProvider);
///   }
/// }
/// ```
/// {@endtemplate}
/// {@category Core}
abstract class ConsumerStatefulWidget extends StatefulWidget {
  /// {@macro riverpod.consumer_stateful_widget}
  const ConsumerStatefulWidget({super.key});

  @override
  ConsumerState createState();

  @override
  ConsumerStatefulElement createElement() => ConsumerStatefulElement(this);
}

/// The [State] for a [ConsumerStatefulWidget].
///
/// It has all the life-cycles if a normal [State], with the only difference
/// being that it has a [ref] property.
///
/// It must be used in conjunction with a [ConsumerStatefulWidget] :
///
/// ```dart
/// class MyConsumer extends ConsumerStatefulWidget {
///  const MyConsumer({Key? key}): super(key: key);
///
///   @override
///   ConsumerState<MyConsumer> createState() => _MyConsumerState();
/// }
///
/// class _MyConsumerState extends ConsumerState<MyConsumer> {
///   @override
///   void initState() {
///     // All State life-cycles can be used
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     // "ref" is a property of ConsumerState and can be used to read providers
///     ref.watch(someProvider);
///   }
/// }
/// ```
/// {@category Core}
abstract class ConsumerState<T extends ConsumerStatefulWidget>
    extends State<T> {
  /// {@macro flutter_riverpod.widget_ref}
  late final WidgetRef ref = context as WidgetRef;
}

/// The [Element] for a [ConsumerStatefulWidget]
@internal
base class ConsumerStatefulElement extends StatefulElement
    implements WidgetRef {
  /// The [Element] for a [ConsumerStatefulWidget]
  ConsumerStatefulElement(ConsumerStatefulWidget super.widget);

  @override
  BuildContext get context => this;

  late ProviderContainer _container = ProviderScope.containerOf(this);
  var _dependencies =
      <ProviderListenable<Object?>, ProviderSubscription<Object?>>{};
  Map<ProviderListenable<Object?>, ProviderSubscription<Object?>>?
      _oldDependencies;
  final _listeners = <ProviderSubscription<Object?>>[];
  List<ProviderSubscription<Object?>>? _manualListeners;
  bool? _visible;

  Iterable<ProviderSubscription> get _allSubscriptions sync* {
    yield* _dependencies.values;
    yield* _listeners;
    if (_manualListeners != null) {
      yield* _manualListeners!;
    }
  }

  void _applyVisibility(ProviderSubscription sub) {
    if (_visible == false) sub.pause();
  }

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
    final visible = Visibility.of(context);
    if (visible != _visible) {
      _visible = visible;
      for (final sub in _allSubscriptions) {
        if (visible) {
          sub.resume();
        } else {
          sub.pause();
        }
      }
    }

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

      final sub = _container.listen<Res>(
        target,
        (_, __) => markNeedsBuild(),
      );
      _applyVisibility(sub);
      return sub;
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
    _applyVisibility(sub);
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
  void invalidate(
    ProviderOrFamily provider, {
    bool asReload = false,
  }) {
    _assertNotDisposed();
    _container.invalidate(provider, asReload: asReload);
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

    final innerSubscription = container.listen<T>(
      provider,
      listener,
      onError: onError,
      fireImmediately: fireImmediately,
      // ignore: invalid_use_of_internal_member, from riverpod
    ) as ProviderSubscriptionWithOrigin<T, Object?>;

    // ignore: invalid_use_of_internal_member, from riverpod
    late final ProviderSubscriptionView<T, Object?> sub;
    sub = ProviderSubscriptionView<T, Object?>(
      innerSubscription: innerSubscription,
      listener: (prev, next) {},
      onError: (error, stackTrace) {},
      onClose: () => _manualListeners?.remove(sub),
      read: innerSubscription.read,
    );
    _applyVisibility(sub);
    listeners.add(sub);

    return sub;
  }
}
