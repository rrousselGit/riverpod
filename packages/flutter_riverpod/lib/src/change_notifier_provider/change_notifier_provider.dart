import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

/// Creates a [ChangeNotifier] and subscribes to it.
///
/// Note: By using Riverpod, [ChangeNotifier] will no-longer be O(N^2) for
/// dispatching notifications and O(N) for adding/removing listeners.
class ChangeNotifierProvider<T extends ChangeNotifier> extends Provider<T> {
  /// Created a [ChangeNotifierProvider] and allows specifying [name].
  ChangeNotifierProvider(Create<T, ProviderReference> create, {String name})
      : super(create, name: name);

  // TODO: ChangeNotifierBuilder
  // static const family = ChangeNotifierProviderFamilyBuilder();
  // static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

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

/// Creates a [ChangeNotifierProvider] from external parameters.
///
/// See also:
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class ChangeNotifierProviderFamily<Result extends ChangeNotifier, A>
    extends Family<ChangeNotifierProvider<Result>, A> {
  /// Creates a [ChangeNotifier] from an external parameter.
  ChangeNotifierProviderFamily(
    Result Function(ProviderReference ref, A a) create,
  ) : super((a) => ChangeNotifierProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
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
