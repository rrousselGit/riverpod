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

BaseProviderState<BaseProviderValue, T, BaseProvider<BaseProviderValue, T>>
    dependOnProviderState<T>(
  BaseProvider<BaseProviderValue, T> provider,
) {
  final scope = useContext()
      .dependOnInheritedWidgetOfExactType<_ProviderStateOwnerScope>();

  if (scope == null) {
    throw StateError('No ProviderScope found');
  }

  // TODO return Hook.use(BaseProviderStateHook(scope.owner, provider));

  return scope.owner.readProviderState(provider);
}

class BaseProviderStateHook<T> extends Hook<T> {
  const BaseProviderStateHook(this._providerState);

  final BaseProviderState<BaseProviderValue, T, BaseProvider<BaseProviderValue, T>>
      _providerState;

  @override
  _ProviderHookState<T> createState() => _ProviderHookState();
}

class _ProviderHookState<T> extends HookState<T, BaseProviderStateHook<T>> {
  T _state;
  VoidCallback _removeListener;

  @override
  T build(BuildContext context) => _state;

  @override
  void initHook() {
    super.initHook();
    _listen(hook._providerState);
  }

  @override
  void didUpdateHook(BaseProviderStateHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (hook._providerState != oldHook._providerState) {
      _listen(hook._providerState);
    }
  }

  void _listen(
    BaseProviderState<BaseProviderValue, T, BaseProvider<BaseProviderValue, T>>
        notifier,
  ) {
    _removeListener?.call();
    _removeListener = notifier.$addStateListener(_listener);
  }

  void _listener(T value) {
    setState(() => _state = value);
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}
