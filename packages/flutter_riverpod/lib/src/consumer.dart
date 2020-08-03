import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internals.dart';

typedef ConsumerBuilder = Widget Function(
    BuildContext context, ScopedReader watch);

/// Listen to a provider and build a widget tree out of it.
///
/// Using [Consumer], this allows the widget tree to listen to changes on provider,
/// so that the UI automatically updates when needed.
///
/// Do not modify any state or start any http request inside `builder`.
///
/// As a usage example, consider:
///
/// ```dart
/// final helloWorldProvider = Provider((_) => 'Hello world');
/// ```
///
/// We can then use [Consumer] to listen to `helloWorldProvider` like so:
///
/// ```dart
/// class Example extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Consumer((context, watch) {
///       final value = watch(helloWorldProvider);
///       return Text(value); // Hello world
///     });
///   }
/// }
/// ```
///
/// **Note**
/// You can watch as many providers inside [Consumer] as you want to:
///
/// ```dart
/// Consumer((context, watch) {
///   final value = watch(someProvider);
///   final another = watch(anotherProvider);
///   ...
/// });
class Consumer extends StatefulWidget {
  /// Subscribes to providers and create widgets out of it
  // ignore: prefer_const_constructors_in_immutables, const is impossible to use with `builder`
  Consumer(ConsumerBuilder builder, {Key key})
      : assert(builder != null, 'the parameter builder cannot be null'),
        _builder = builder,
        super(key: key);

  final ConsumerBuilder _builder;

  @override
  _ConsumerState createState() => _ConsumerState();
}

class _ConsumerState extends State<Consumer> {
  ProviderContainer _container;
  var _dependencies = <ProviderBase, ProviderSubscription>{};
  Map<ProviderBase, ProviderSubscription> _oldDependencies;
  bool _debugSelecting;
  Widget _buildCache;
  // initialized at true for the first build
  bool _isExternalBuild = true;

  @override
  void didUpdateWidget(Consumer oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      return _buildCache = widget._builder(context, _reader);
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
      'Cannot use `read` outside of the body of the Consumer callback',
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
