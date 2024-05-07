// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pipe_change_notifier.g.dart';

/* SNIPPET START */
// {@template provider}
/// A provider which creates a ValueNotifier and update its listeners
/// whenever the value changes.
// {@endtemplate}
@riverpod
ValueNotifier<int> myListenable(MyListenableRef ref) {
  final notifier = ValueNotifier(0);

  // {@template onDispose}
  // Dispose of the notifier when the provider is destroyed
  // {@endtemplate}
  ref.onDispose(notifier.dispose);

  // {@template addListener}
  // Notify listeners of this provider whenever the ValueNotifier updates.
  // {@endtemplate}
  notifier.addListener(ref.notifyListeners);

  return notifier;
}
