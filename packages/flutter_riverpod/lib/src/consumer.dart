import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internal.dart';

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

  final ProviderBase<ProviderSubscriptionBase, T> _provider;
  final Widget _child;
  final ValueWidgetBuilder<T> _builder;

  @override
  _ConsumerState<T> createState() => _ConsumerState<T>();
}

class _ConsumerState<T> extends State<Consumer<T>> {
  VoidCallback _removeListener;
  T _value;
  ProviderStateOwner _owner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final owner = ProviderStateOwnerScope.of(context);
    if (_owner != owner) {
      _owner = owner;
      _removeListener?.call();
      _removeListener = widget._provider.watchOwner(owner, (value) {
        setState(() => _value = value);
      });
    }
  }

  @override
  void didUpdateWidget(Consumer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._provider != widget._provider) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: UnsupportedError(
            'Changing the provider listened of a Consumer is not supported',
          ),
          library: 'flutter_provider',
          stack: StackTrace.current,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(context, _value, widget._child);
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}
