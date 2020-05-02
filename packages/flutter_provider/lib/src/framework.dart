import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
          });
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

  static ProviderStateOwner of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ProviderStateOwnerScope>();

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

T useProvider<T>(
  BaseProvider<BaseProviderValue, T> provider,
) {
  final owner = ProviderStateOwnerScope.of(useContext());

  return Hook.use(_BaseProviderStateHook<T>(owner, provider));
}

class _BaseProviderStateHook<T> extends Hook<T> {
  const _BaseProviderStateHook(
    this._owner,
    this._provider,
  );

  final ProviderStateOwner _owner;
  final BaseProvider<BaseProviderValue, T> _provider;

  @override
  _ProviderHookState<T> createState() => _ProviderHookState();
}

class _ProviderHookState<T> extends HookState<T, _BaseProviderStateHook<T>> {
  T _state;
  VoidCallback _removeListener;

  @override
  T build(BuildContext context) => _state;

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  void _listen() {
    _removeListener?.call();
    _removeListener = hook._provider.watchOwner(hook._owner, (value) {
      setState(() => _state = value);
    });
  }

  @override
  void didUpdateHook(_BaseProviderStateHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (oldHook._provider != hook._provider || oldHook._owner != hook._owner) {
      _listen();
    }
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}
