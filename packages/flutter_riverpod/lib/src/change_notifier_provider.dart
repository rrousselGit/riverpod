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
T _listenNotifier<T extends ChangeNotifier?>(
  T notifier,
  ProviderElement<T> ref,
) {
  if (notifier != null) {
    notifier.addListener(ref.notifyListeners);
    ref.onDispose(() => notifier.removeListener(ref.notifyListeners));
  }

  return notifier;
}

Override _overrideWithValue<T extends ChangeNotifier>(
  ProviderBase provider,
  T value,
) {
  return ProviderOverride(
    ValueProvider<T>((ref) {
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
