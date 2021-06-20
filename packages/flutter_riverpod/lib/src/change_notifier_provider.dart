import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

import 'builders.dart';

part 'change_notifier_provider/auto_dispose.dart';
part 'change_notifier_provider/base.dart';

/// {@template riverpod.changenotifierprovider}
/// Creates a [ChangeNotifier] and subscribes to it.
///
/// Note: By using Riverpod, [ChangeNotifier] will no-longer be O(N^2) for
/// dispatching notifications, but instead O(N)
/// {@endtemplate}
T _listenNotifier<T extends ChangeNotifier?>(
  T notifier,
  ProviderElementBase<T> ref,
) {
  if (notifier != null) {
    notifier.addListener(ref.notifyListeners);
    ref.onDispose(() => notifier.removeListener(ref.notifyListeners));
  }

  return notifier;
}
