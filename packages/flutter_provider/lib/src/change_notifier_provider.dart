import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/internals.dart';

class ChangeNotifierProviderValue<T> extends BaseProviderValue {
  ChangeNotifierProviderValue._(this.value);

  final T value;
}

class ChangeNotifierProvider<T extends ChangeNotifier>
    extends BaseProvider<ChangeNotifierProviderValue<T>, T> {
  ChangeNotifierProvider(this._create);

  final Create<T, ProviderState> _create;

  T readOwner(ProviderStateOwner owner) {
    final state = owner.readProviderState(this);
    return state.$state;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends BaseProviderState<ChangeNotifierProviderValue<T>, T,
        ChangeNotifierProvider<T>> {
  @override
  T initState() {
    return provider._create(ProviderState(this))..addListener(_listener);
  }

  void _listener() {
    $state = $state;
  }

  @override
  ChangeNotifierProviderValue<T> createProviderState() {
    return ChangeNotifierProviderValue._($state);
  }

  @override
  void dispose() {
    $state
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }
}
