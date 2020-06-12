import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

class ChangeNotifierProviderDependency<T> extends ProviderDependencyBase {
  ChangeNotifierProviderDependency._(this.value);

  final T value;
}

class ChangeNotifierProvider<T extends ChangeNotifier>
    extends AlwaysAliveProvider<ChangeNotifierProviderDependency<T>, T> {
  ChangeNotifierProvider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends ProviderStateBase<ChangeNotifierProviderDependency<T>, T,
        ChangeNotifierProvider<T>> {
  @override
  T state;

  @override
  void initState() {
    state = provider._create(ProviderReference(this))
      ..addListener(markMayHaveChanged);
  }

  @override
  ChangeNotifierProviderDependency<T> createProviderDependency() {
    return ChangeNotifierProviderDependency._(state);
  }

  @override
  void dispose() {
    state
      ..removeListener(markMayHaveChanged)
      ..dispose();
    super.dispose();
  }
}
