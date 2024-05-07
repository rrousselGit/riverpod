// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_pipe_change_notifier.g.dart';

/* SNIPPET START */
extension on Ref {
  // {@template extension}
  // We can move the previous logic to a Ref extension.
  // This enables reusing the logic between providers
  // {@endtemplate}
  T disposeAndListenChangeNotifier<T extends ChangeNotifier>(T notifier) {
    onDispose(notifier.dispose);
    notifier.addListener(notifyListeners);
    // {@template return}
    // We return the notifier to ease the usage a bit
    // {@endtemplate}
    return notifier;
  }
}

@riverpod
ValueNotifier<int> myListenable(MyListenableRef ref) {
  return ref.disposeAndListenChangeNotifier(ValueNotifier(0));
}

@riverpod
ValueNotifier<int> anotherListenable(AnotherListenableRef ref) {
  return ref.disposeAndListenChangeNotifier(ValueNotifier(42));
}
