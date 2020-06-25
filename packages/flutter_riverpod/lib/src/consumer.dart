import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internal.dart';

typedef ConsumerBuilder = Widget Function(BuildContext context, Reader read);

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
  ProviderStateOwner _owner;
  final _dependencies = <ProviderBase, _Dependency>{};
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
    final newOwner = ProviderStateOwnerScope.of(context);
    if (_owner != newOwner) {
      _owner = newOwner;
      for (final dependency in _dependencies.values) {
        dependency.subscription.close();
      }
      _dependencies.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var didFlush = false;
    for (final dep in _dependencies.values) {
      if (dep.subscription.flush()) {
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
      return _buildCache = widget._builder(context, _reader);
    } finally {
      assert(() {
        _debugSelecting = false;
        return true;
      }(), '');
    }
  }

  Res _reader<Res>(ProviderBase<ProviderDependencyBase, Res> target) {
    assert(
      _debugSelecting,
      'Cannot use `read` outside of the body of the Consumer callback',
    );
    return _dependencies.putIfAbsent(target, () {
      final state = _owner.readProviderState(target);

      final dep = _Dependency();
      dep.subscription = state.addLazyListener(
        mayHaveChanged: (context as Element).markNeedsBuild,
        onChange: (value) => dep._state = value,
      );
      return dep;
    })._state as Res;
  }

  @override
  void dispose() {
    for (final dependency in _dependencies.values) {
      dependency.subscription.close();
    }
    super.dispose();
  }
}

class _Dependency {
  ProviderSubscription subscription;
  Object _state;
}
