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
    void listener() {
      ref.setState(notifier);
    }

    notifier.addListener(listener);
    ref.onDispose(() {
      try {
        notifier.removeListener(listener);
        // ignore: empty_catches, may throw if called after the notifier is dispose, but this is safe to ignore.
      } catch (err) {}
    });
  }

  return notifier;
}

// ignore: subtype_of_sealed_class
/// Add [overrideWithValue] to [AutoDisposeStateNotifierProvider]
mixin ChangeNotifierProviderOverrideMixin<Notifier extends ChangeNotifier?>
    on ProviderBase<Notifier> {
  ///
  ProviderBase<Notifier> get notifier;

  @override
  late final List<ProviderOrFamily>? dependencies = [notifier];

  /// {@macro riverpod.overrridewithvalue}
  Override overrideWithValue(Notifier value) {
    return ProviderOverride(
      origin: notifier,
      override: ValueProvider<Notifier>(value),
    );
  }
}
