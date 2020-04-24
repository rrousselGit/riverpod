import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:provider/src/framework/framework.dart' show OwnerPutIfAbsent;

class ProviderScope extends StatefulWidget {
  /// Creates a [ProviderScope] and optionally allows overriding providers.
  const ProviderScope({
    Key key,
    this.overrides = const [],
    @required this.child,
  })  : assert(child != null, 'child cannot be `null`'),
        super(key: key);

  ///
  @visibleForTesting
  final Widget child;

  @visibleForTesting
  final List<ProviderOverride<Object>> overrides;

  @override
  _ProviderScopeState createState() => _ProviderScopeState();
}

class _ProviderScopeState extends State<ProviderScope> {
  ProviderStateOwner _owner;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ProviderScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _owner.updateOverrides(widget.overrides);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ancestorOwner = context
        .dependOnInheritedWidgetOfExactType<_ProviderStateOwnerScope>()
        ?.owner;

    if (_owner == null) {
      _owner = ProviderStateOwner(
          parent: ancestorOwner,
          overrides: widget.overrides,
          onError: (dynamic error, stack) {
            FlutterError.reportError(
              FlutterErrorDetails(
                library: 'flutter_provider',
                exception: error,
                stack: stack,
              ),
            );
          });
    } else {
      _owner.updateParent(ancestorOwner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ProviderStateOwnerScope(
      owner: _owner,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _owner.dispose();
    super.dispose();
  }
}

class _ProviderStateOwnerScope extends InheritedWidget {
  const _ProviderStateOwnerScope({
    Key key,
    @required this.owner,
    Widget child,
  })  : assert(owner != null, 'ProviderStateOwner cannot be null'),
        super(key: key, child: child);

  final ProviderStateOwner owner;

  @override
  bool updateShouldNotify(_ProviderStateOwnerScope oldWidget) {
    return owner != oldWidget.owner;
  }
}

BaseProviderState<T, BaseProvider<T>> dependOnProviderState<T>(
  BaseProvider<T> provider,
) {
  final scope = useContext()
      .dependOnInheritedWidgetOfExactType<_ProviderStateOwnerScope>();

  if (scope == null) {
    throw StateError('No ProviderScope found');
  }

  return scope.owner.readProviderState(provider);
}
