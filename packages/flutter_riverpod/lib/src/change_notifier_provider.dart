// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'builders.dart';

part 'change_notifier_provider/base.dart';
part 'change_notifier_provider/auto_dispose.dart';

/// {@template riverpod.changenotifierprovider}
/// Creates a [ChangeNotifier] and subscribes to it.
///
/// Note: By using Riverpod, [ChangeNotifier] will no-longer be O(N^2) for
/// dispatching notifications, but instead O(N)
/// {@endtemplate}
mixin _ChangeNotifierProviderStateMixin<T extends ChangeNotifier?>
    on ProviderStateBase<T, T> {
  @override
  void valueChanged({T? previous}) {
    if (createdValue == previous) {
      return;
    }
    previous?.removeListener(_listener);
    previous?.dispose();
    exposedValue = createdValue;
    createdValue?.addListener(_listener);
  }

  void _listener() {
    exposedValue = createdValue;
  }

  @override
  void dispose() {
    createdValue?.removeListener(_listener);
    createdValue?.dispose();
    super.dispose();
  }
}

Override _overrideWithValue<T extends ChangeNotifier>(
  ProviderBase provider,
  T value,
) {
  return ProviderOverride(
    ValueProvider<T, T>((ref) {
      VoidCallback? removeListener;

      void listen(T value) {
        removeListener?.call();
        // ignore: invalid_use_of_protected_member
        value.addListener(ref.markDidChange);
        // ignore: invalid_use_of_protected_member
        removeListener = () => value.removeListener(ref.markDidChange);
      }

      listen(value);
      ref.onChange = listen;

      ref.onDispose(() => removeListener?.call());
      return value;
    }, value),
    provider,
  );
}
