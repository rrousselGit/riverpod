import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

class ChangeNotifierProviderSubscription<T> extends ProviderBaseSubscription {
  ChangeNotifierProviderSubscription._(this.value);

  final T value;
}

class ChangeNotifierProvider<T extends ChangeNotifier>
    extends AlwaysAliveProvider<ChangeNotifierProviderSubscription<T>, T> {
  ChangeNotifierProvider(this._create);

  final Create<T, ProviderContext> _create;

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends ProviderBaseState<ChangeNotifierProviderSubscription<T>, T,
        ChangeNotifierProvider<T>> {
  @override
  T initState() {
    return provider._create(ProviderContext(this))..addListener(_listener);
  }

  void _listener() {
    $state = $state;
  }

  @override
  ChangeNotifierProviderSubscription<T> createProviderSubscription() {
    return ChangeNotifierProviderSubscription._($state);
  }

  @override
  void dispose() {
    $state
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }
}
