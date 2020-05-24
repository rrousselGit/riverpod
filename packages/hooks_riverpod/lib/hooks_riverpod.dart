// ignore: implementation_imports
import 'package:flutter_riverpod/src/internal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

T useProvider<T>(ProviderBase<ProviderBaseSubscription, T> provider) {
  final owner = ProviderStateOwnerScope.of(useContext());
  return Hook.use(_BaseProviderHook<T>(owner, provider));
}

class _BaseProviderHook<T> extends Hook<T> {
  const _BaseProviderHook(
    this._owner,
    this._provider,
  );

  final ProviderStateOwner _owner;
  final ProviderBase<ProviderBaseSubscription, T> _provider;

  @override
  _BaseProviderHookState<T> createState() => _BaseProviderHookState();
}

class _BaseProviderHookState<T> extends HookState<T, _BaseProviderHook<T>> {
  VoidCallback _removeListener;
  T _value;

  @override
  T build(BuildContext context) => _value;

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  void _listen() {
    _removeListener?.call();
    _removeListener = hook._provider.watchOwner(hook._owner, (value) {
      setState(() => _value = value);
    });
  }

  @override
  void didUpdateHook(_BaseProviderHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (oldHook._provider != hook._provider) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: UnsupportedError(
            'Used `useMyProvider()` with a `useMyProvider` different than it was before',
          ),
          library: 'flutter_provider',
          stack: StackTrace.current,
        ),
      );
    }
    if (oldHook._owner != hook._owner) {
      _listen();
    }
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}
