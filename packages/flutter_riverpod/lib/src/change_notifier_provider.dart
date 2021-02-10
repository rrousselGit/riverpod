// ignore: implementation_imports
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'builders.dart';
import 'internals.dart';

part 'change_notifier_provider/auto_dispose.dart';
part 'change_notifier_provider/base.dart';

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

  @override
  void exposedValueChanged(T newValue) {
    exposedValue?.removeListener(_listener);
    exposedValue?.dispose();
    exposedValue = newValue;
    newValue?.addListener(_listener);
  }

  void _listener() {
    exposedValue = createdValue;
  }

  @override
  void dispose() {
    exposedValue?.removeListener(_listener);
    exposedValue?.dispose();
    super.dispose();
  }
}
