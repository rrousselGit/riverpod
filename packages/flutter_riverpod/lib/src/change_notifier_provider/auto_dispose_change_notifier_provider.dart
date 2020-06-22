import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

/// Creates a [ChangeNotifier] and subscribes to it.
///
/// Note: By using Riverpod, [ChangeNotifier] will no-longer be O(N^2) for
/// dispatching notifications and O(N) for adding/removing listeners.
class AutoDisposeChangeNotifierProvider<T extends ChangeNotifier>
    extends AutoDisposeProvider<T> {
  /// Created a [AutoDisposeChangeNotifierProvider] and allows specifying [name].
  AutoDisposeChangeNotifierProvider(
    Create<T, AutoDisposeProviderReference> create, {
    String name,
  }) : super(create, name: name);

  @override
  _AutoDisposeChangeNotifierProviderState<T> createState() =>
      _AutoDisposeChangeNotifierProviderState();
}

class _AutoDisposeChangeNotifierProviderState<T extends ChangeNotifier>
    extends AutoDisposeProviderState<T> {
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

/// Creates a [AutoDisposeChangeNotifierProvider] from external parameters.
///
/// See also:
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class AutoDisposeChangeNotifierProviderFamily<Result extends ChangeNotifier, A>
    extends Family<AutoDisposeChangeNotifierProvider<Result>, A> {
  /// Creates a [ChangeNotifier] from an external parameter.
  AutoDisposeChangeNotifierProviderFamily(
    Result Function(AutoDisposeProviderReference ref, A a) create,
  ) : super((a) => AutoDisposeChangeNotifierProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(AutoDisposeProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) {
        return AutoDisposeChangeNotifierProvider<Result>(
          (ref) => override(ref, value as A),
        );
      },
    );
  }
}
