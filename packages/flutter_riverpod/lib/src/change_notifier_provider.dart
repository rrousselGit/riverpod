import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

/// Creates a [ChangeNotifier] and subscribes to it.
/// 
/// Note: By using Riverpod, [ChangeNotifier] will no-longer be O(N^2) for
/// dispatching notifications and O(N) for adding/removing listeners.
class ChangeNotifierProvider<T extends ChangeNotifier>
    extends AlwaysAliveProvider<ProviderDependency<T>, T> {
  ChangeNotifierProvider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends ProviderStateBase<ProviderDependency<T>, T,
        ChangeNotifierProvider<T>> {
  @override
  T state;

  @override
  void initState() {
    state = provider._create(ProviderReference(this))
      ..addListener(markMayHaveChanged);
  }

  @override
  ProviderDependency<T> createProviderDependency() {
    return ProviderDependencyImpl(state);
  }

  @override
  void dispose() {
    state
      ..removeListener(markMayHaveChanged)
      ..dispose();
    super.dispose();
  }
}
