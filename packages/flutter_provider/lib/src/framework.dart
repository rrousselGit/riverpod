import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'internal.dart';

class ProviderScope extends StatefulWidget {
  const ProviderScope({
    Key key,
    this.overrides = const [],
    @required this.child,
  })  : assert(child != null, 'child cannot be `null`'),
        super(key: key);

  @visibleForTesting
  final Widget child;

  @visibleForTesting
  final List<ProviderOverride<BaseProviderValue, Object>> overrides;

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
        .dependOnInheritedWidgetOfExactType<ProviderStateOwnerScope>()
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
        },
      );
    } else {
      _owner.updateParent(ancestorOwner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderStateOwnerScope(
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

class ProviderStateOwnerScope extends InheritedWidget {
  const ProviderStateOwnerScope({
    Key key,
    @required this.owner,
    Widget child,
  })  : assert(owner != null, 'ProviderStateOwner cannot be null'),
        super(key: key, child: child);

  static ProviderStateOwner of(BuildContext context, {bool listen = true}) {
    ProviderStateOwnerScope scope;

    if (listen) {
      scope = context //
          .dependOnInheritedWidgetOfExactType<ProviderStateOwnerScope>();
    } else {
      scope = context
          .getElementForInheritedWidgetOfExactType<ProviderStateOwnerScope>()
          .widget as ProviderStateOwnerScope;
    }

    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    return scope.owner;
  }

  final ProviderStateOwner owner;

  @override
  bool updateShouldNotify(ProviderStateOwnerScope oldWidget) {
    return owner != oldWidget.owner;
  }
}
