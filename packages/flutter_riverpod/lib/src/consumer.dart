import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'framework.dart';
import 'internals.dart';

/// A function that can also listen to providers
///
/// See also [Consumer]
typedef ConsumerBuilder = Widget Function(
  BuildContext context,
  ScopedReader watch,
  Widget child,
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
///       builder: (context, watch, child) {
///         final value = watch(helloWorldProvider);
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
///   builder: (context, watch, child) {
///     final value = watch(someProvider);
///     final another = watch(anotherProvider);
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
/// class MyHomePage extends StatelessWidget {
///   MyHomePage({Key key, this.title}) : super(key: key);
///   final String title;
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(widget.title)
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             Text('You have pushed the button this many times:'),
///             Consumer(
///               builder: (BuildContext context, ScopedReader watch, Widget child) {
///                 // This builder will only get called when the counterProvider
///                 // is updated.
///                 final count = watch(counterProvider).state;
///
///                 return Row(
///                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///                   children: <Widget>[
///                     Text('$count'),
///                     child,
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
///         onPressed: () => context.read(counterProvider).state++,
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
  /// {@template riverpod.consumer}
  const Consumer({
    Key key,
    @required ConsumerBuilder builder,
    Widget child,
  })  : _child = child,
        _builder = builder,
        assert(builder != null, 'the parameter builder cannot be null'),
        super(key: key);

  final ConsumerBuilder _builder;
  final Widget _child;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return _builder(context, watch, _child);
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
///   const Example({Key key}): super(key: key);
///
///   @override
///   Widget build(BuildContext context, ScopedReader watch) {
///     final value = watch(helloWorldProvider);
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
/// Widget build(BuildContext context, ScopedReader watch) {
///   final value = watch(someProvider);
///   final another = watch(anotherProvider);
///   return Text(value); // Hello world
/// }
/// ```
///
/// For reading providers inside a [StatefulWidget] or for performance
/// optimizations, see [Consumer].
/// {@endtemplate}
abstract class ConsumerWidget extends StatefulWidget {
  /// {@macro riverpod.consumerwidget}
  const ConsumerWidget({Key key}) : super(key: key);

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
  Widget build(BuildContext context, ScopedReader watch);

  @override
  _ConsumerState createState() => _ConsumerState();
}

@sealed
class _ConsumerState extends State<ConsumerWidget> {
  ProviderContainer _container;
  var _dependencies = <ProviderBase, ProviderSubscription>{};
  Map<ProviderBase, ProviderSubscription> _oldDependencies;
  bool _debugSelecting;
  Widget _buildCache;
  // initialized at true for the first build
  bool _isExternalBuild = true;

  @override
  void didUpdateWidget(ConsumerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isExternalBuild = true;
  }

  @override
  void reassemble() {
    super.reassemble();
    _isExternalBuild = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isExternalBuild = true;
    final newContainer = ProviderScope.containerOf(context);
    if (_container != newContainer) {
      _container = newContainer;
      for (final dependency in _dependencies.values) {
        dependency.close();
      }
      _dependencies.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var didFlush = false;
    for (final dep in _dependencies.values) {
      if (dep.flush()) {
        didFlush = true;
      }
    }
    final shouldRecompute = _isExternalBuild || didFlush;
    _isExternalBuild = false;
    if (!shouldRecompute) {
      return _buildCache;
    }

    assert(() {
      _debugSelecting = true;
      return true;
    }(), '');
    try {
      _oldDependencies = _dependencies;
      _dependencies = {};
      return _buildCache = widget.build(context, _reader);
    } finally {
      assert(() {
        _debugSelecting = false;
        return true;
      }(), '');
      for (final dep in _oldDependencies.values) {
        dep.close();
      }
      _oldDependencies = null;
    }
  }

  Res _reader<Res>(ProviderBase<Object, Res> target) {
    assert(
      _debugSelecting,
      'Cannot use `watch` outside of the body of the Consumer callback',
    );
    return _dependencies.putIfAbsent(target, () {
      final oldDependency = _oldDependencies?.remove(target);

      if (oldDependency != null) {
        return oldDependency;
      }

      return _container.listen<Res>(
        target,
        mayHaveChanged: _mayHaveChanged,
      );
    }).read() as Res;
  }

  void _mayHaveChanged(ProviderSubscription sub) {
    (context as Element).markNeedsBuild();
  }

  @override
  void dispose() {
    for (final dependency in _dependencies.values) {
      dependency.close();
    }
    super.dispose();
  }
}
