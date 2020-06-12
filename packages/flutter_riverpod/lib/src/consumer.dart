import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internal.dart';

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
class Consumer<T> extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables, const is impossible to use with `builder`
  Consumer(
    this._provider, {
    Key key,
    @required ValueWidgetBuilder<T> builder,
    Widget child,
  })  : assert(builder != null, 'the parameter builder cannot be null'),
        _child = child,
        _builder = builder,
        super(key: key);

  final ProviderListenable<T> _provider;
  final Widget _child;
  final ValueWidgetBuilder<T> _builder;

  @override
  _ConsumerState<T> createState() => _ConsumerState<T>();
}

class _ConsumerState<T> extends State<Consumer<T>> {
  ProviderSubscription _subscription;
  T _value;
  ProviderStateOwner _owner;
  Widget _buildCache;
  bool _isOptionalRebuild = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final owner = ProviderStateOwnerScope.of(context);
    if (_owner != owner) {
      _owner = owner;
      _subscription?.close();
      _subscription = widget._provider.addLazyListener(
        owner,
        mayHaveChanged: _markMayNeedRebuild,
        onChange: _onChange,
      );
    }
  }

  void _onChange(T value) {
    setState(() {
      _value = value;
    });
  }

  void _markMayNeedRebuild() {
    // TODO test
    if (_isOptionalRebuild != false) {
      setState(() {
        _isOptionalRebuild = true;
      });
    }
  }

  @override
  void didUpdateWidget(Consumer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(
      oldWidget._provider.runtimeType == widget._provider.runtimeType,
      'The provider listened cannot change',
    );
    _isOptionalRebuild = false;
    final subscription = _subscription;
    if (subscription is SelectorSubscription<Object, T>) {
      // this will update _state
      subscription.updateSelector(widget._provider);
    } else if (oldWidget._provider != widget._provider) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: UnsupportedError(
            'Used `Consumer(provider)` with a `provider` different than it was before',
          ),
          library: 'flutter_provider',
          stack: StackTrace.current,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mustRebuild = _isOptionalRebuild != true || _subscription.flush();
    _isOptionalRebuild = null;
    if (!mustRebuild) {
      return _buildCache;
    }

    return _buildCache = widget._builder(context, _value, widget._child);
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}
