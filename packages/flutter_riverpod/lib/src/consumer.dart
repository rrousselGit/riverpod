import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internals.dart';

typedef ConsumerBuilder = Widget Function(BuildContext context, Reader watch);

/// Listen to a provider and build a widget tree out of it.
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
///     return Consumer<String>(
///       helloWorldProvider,
///       builder: (context, value, child) {
///         return Text(value); // Hello world
///       },
///     );
///   }
/// }
/// ```
///
/// # Optimising rebuilds with `child`
///
/// [Consumer] provides an optional `child` parameter to optimise rebuilds of
/// the widget tree when a part of it doesn't depend on the listened value.
///
/// For example, we may have:
///
/// ```dart
/// Consumer<MyTheme>(
///   themeProvider,
///   builder: (context, theme, child) {
///     return ColoredBox(
///       color: theme.primaryColor,
///       child: Text('hello world'),
///     );
///   }
/// )
/// ```
///
/// This is not ideal as [Text] is inside `builder` but doesn't depend on `themeProvider`.
/// As such, when the theme change, [Text] will rebuild for no reason.
///
///
/// We could use `child` to optimise such code by writing the following:
///
/// ```dart
/// Consumer<MyTheme>(
///   themeProvider,
///   builder: (context, theme, child) {
///     return ColoredBox(
///       color: theme.primaryColor,
///       child: child,
///     );
///   },
///   child: Text('hello world'),
/// )
/// ```
///
/// Notice how the [Text] is built outside of `builder`, so it'll no-longer
/// rebuild when `themeProvider` changes.
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
    final newContainer = ProviderContainerScope.of(context);
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
