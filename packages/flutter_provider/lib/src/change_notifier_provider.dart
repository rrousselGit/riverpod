import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/internals.dart';

class ChangeNotifierProviderValue<T> extends BaseProviderValue {
  ChangeNotifierProviderValue._(this.value);

  final T value;
}

class ChangeNotifierProvider<T extends ChangeNotifier>
    extends AlwaysAliveProvider<ChangeNotifierProviderValue<T>, T> {
  ChangeNotifierProvider(this._create);

  final Create<T, ProviderState> _create;

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
  ChangeNotifierProviderValue<T> createProviderValue() {
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
