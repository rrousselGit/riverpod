import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';

import 'framework.dart';
import 'internal.dart';

extension BaseProviderHook<T> on BaseProvider<BaseProviderValue, T> {
  T call() {
    final owner = ProviderStateOwnerScope.of(useContext());
    return Hook.use(_BaseProviderHook<T>(owner, this));
  }

  Res select<Res>(Res Function(T value) selector) {
    final owner = ProviderStateOwnerScope.of(useContext());
    return Hook.use(_BaseProviderSelectorHook<T, Res>(owner, this, selector));
  }
}

extension AlwaysAliveProviderX<CombiningValue extends BaseProviderValue,
    ListenedValue> on AlwaysAliveProvider<CombiningValue, ListenedValue> {
  ListenedValue read(BuildContext context) {
    assert(() {
      if (context.debugDoingBuild) {
        throw UnsupportedError(
            'Cannot call `provider.read(context)` inside `build`');
      }
      return true;
    }(), '');

    return readOwner(ProviderStateOwnerScope.of(context, listen: false));
  }
}

class _BaseProviderSelectorHook<Input, Output> extends Hook<Output> {
  const _BaseProviderSelectorHook(
    this._owner,
    this._provider,
    this._selector,
  );

  final ProviderStateOwner _owner;
  final BaseProvider<BaseProviderValue, Input> _provider;
  final Output Function(Input) _selector;

  @override
  _BaseProviderSelectorHookState<Input, Output> createState() =>
      _BaseProviderSelectorHookState();
}

class _BaseProviderSelectorHookState<Input, Output>
    extends HookState<Output, _BaseProviderSelectorHook<Input, Output>> {
  Output _state;
  Input _lastValue;
  VoidCallback _removeListener;

  @override
  Output build(BuildContext context) => _state;

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  void _listen() {
    _removeListener?.call();
    _removeListener = hook._provider.watchOwner(hook._owner, (value) {
      _lastValue = value;
      final selected = hook._selector(value);
      if (!const DeepCollectionEquality().equals(_state, selected)) {
        setState(() => _state = selected);
      }
    });
  }

  @override
  void didUpdateHook(_BaseProviderSelectorHook<Input, Output> oldHook) {
    super.didUpdateHook(oldHook);
    if (oldHook._provider != hook._provider) {
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
    if (oldHook._owner != hook._owner) {
      _listen();
    } else {
      _state = hook._selector(_lastValue);
    }
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}

class _BaseProviderHook<T> extends Hook<T> {
  const _BaseProviderHook(
    this._owner,
    this._provider,
  );

  final ProviderStateOwner _owner;
  final BaseProvider<BaseProviderValue, T> _provider;

  @override
  _BaseProviderHookState<T> createState() => _BaseProviderHookState();
}

class _BaseProviderHookState<T> extends HookState<T, _BaseProviderHook<T>> {
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
