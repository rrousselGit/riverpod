// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';
import 'package:flutter/widgets.dart';

import 'builders.dart';

part 'change_notifier_provider/base.dart';
part 'change_notifier_provider/auto_dispose.dart';

/// {@template riverpod.streamprovider}
/// Hello world
/// {@endtemplate}
mixin _ChangeNotifierProviderStateMixin<T extends ChangeNotifier>
    on ProviderStateBase<T, T> {
  @override
  void valueChanged({T previous}) {
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
