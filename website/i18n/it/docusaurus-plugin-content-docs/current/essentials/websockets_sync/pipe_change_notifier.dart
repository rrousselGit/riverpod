// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pipe_change_notifier.g.dart';

/* SNIPPET START */
/// A provider which creates a ValueNotifier and update its listeners
/// whenever the value changes.
@riverpod
ValueNotifier<int> myListenable(MyListenableRef ref) {
  final notifier = ValueNotifier(0);

  // Smaltiamo il notifier quando il provider viene distrutto
  ref.onDispose(notifier.dispose);

  // Notifica i listener di questo provider ogni volta che il ValueNotifier si aggiorna.
  notifier.addListener(ref.notifyListeners);

  return notifier;
}
