// ignore: implementation_imports
import 'package:flutter_river_pod/src/internal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';

export 'package:flutter_river_pod/flutter_river_pod.dart';

Output useSelector<Input, Output>(SelectorDelegate<Input, Output> selector) {
  final owner = ProviderStateOwnerScope.of(useContext());
  return Hook.use(_BaseProviderSelectorHook<Input, Output>(owner, selector));
}

class _BaseProviderSelectorHook<Input, Output> extends Hook<Output> {
  const _BaseProviderSelectorHook(
    this._owner,
    this._selector,
  );

  final ProviderStateOwner _owner;
  final SelectorDelegate<Input, Output> _selector;

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
    _removeListener =
        hook._selector.watchOwner(hook._owner, (value, lastValue) {
      _lastValue = lastValue;
      if (hook._selector.shouldRebuild(_state, value)) {
        setState(() => _state = value);
      }
    });
  }

  @override
  void didUpdateHook(_BaseProviderSelectorHook<Input, Output> oldHook) {
    super.didUpdateHook(oldHook);
    if (oldHook._selector.provider != hook._selector.provider) {
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
      _state = hook._selector.transform(_lastValue);
    }
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}

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

@immutable
abstract class SelectorDelegate<Input, Output> {
  ProviderBase<ProviderBaseSubscription, Input> get provider;

  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(Output value, Input originValue) listener,
  );

  Output transform(Input value);

  bool shouldRebuild(Output previousValue, Output newValue);
}

class _SelectorDelegate<Input, Output>
    implements SelectorDelegate<Input, Output> {
  _SelectorDelegate(this._selector, this.provider);

  final Output Function(Input value) _selector;
  @override
  final ProviderBase<ProviderBaseSubscription, Input> provider;

  @override
  Output transform(Input value) {
    return _selector(value);
  }

  @override
  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(Output value, Input originValue) listener,
  ) {
    return provider.watchOwner(
      owner,
      (value) => listener(_selector(value), value),
    );
  }

  @override
  bool shouldRebuild(Output previousValue, Output newValue) {
    return !const DeepCollectionEquality().equals(previousValue, newValue);
  }
}

extension ProviderSelectX<ListenedValue>
    on ProviderBase<ProviderBaseSubscription, ListenedValue> {
  SelectorDelegate<ListenedValue, Res> select<Res>(
    Res Function(ListenedValue value) selector,
  ) {
    return _SelectorDelegate<ListenedValue, Res>(selector, this);
  }
}
