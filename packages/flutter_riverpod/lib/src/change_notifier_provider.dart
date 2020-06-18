import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

/// Creates a [ChangeNotifier] and subscribes to it.
///
/// Note: By using Riverpod, [ChangeNotifier] will no-longer be O(N^2) for
/// dispatching notifications and O(N) for adding/removing listeners.
class ChangeNotifierProvider<T extends ChangeNotifier> extends Provider<T> {
  ChangeNotifierProvider(Create<T, ProviderReference> create, {String name})
      : super(create, name: name);

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends ProviderState<T> {
  @override
  void initState() {
    super.initState();
    state.addListener(markMayHaveChanged);
  }

  @override
  void dispose() {
    state
      ..removeListener(markMayHaveChanged)
      ..dispose();
    super.dispose();
  }
}

class ChangeNotifierProviderFamily<Result extends ChangeNotifier, A>
    extends Family<ChangeNotifierProvider<Result>, A> {
  ChangeNotifierProviderFamily(
    Result Function(ProviderReference ref, A a) create,
  ) : super((a) => ChangeNotifierProvider((ref) => create(ref, a)));

  FamilyOverride overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) {
        return ChangeNotifierProvider<Result>(
          (ref) => override(ref, value as A),
        );
      },
    );
  }
}
