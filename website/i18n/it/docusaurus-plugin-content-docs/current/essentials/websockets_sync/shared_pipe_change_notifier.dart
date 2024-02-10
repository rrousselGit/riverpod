// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_pipe_change_notifier.g.dart';

/* SNIPPET START */
extension on Ref<Object?> {
  // Possiamo spostare la logica precedente in una estensione Ref.
  // Questo abilita il riutilizzo della logica
  T disposeAndListenChangeNotifier<T extends ChangeNotifier>(T notifier) {
    onDispose(notifier.dispose);
    notifier.addListener(notifyListeners);
    // Restituiamo il notifier per facilitarne di un poco l'utilizzo
    return notifier;
  }
}

@riverpod
Raw<ValueNotifier<int>> myListenable(MyListenableRef ref) {
  return ref.disposeAndListenChangeNotifier(ValueNotifier(0));
}

@riverpod
Raw<ValueNotifier<int>> anotherListenable(AnotherListenableRef ref) {
  return ref.disposeAndListenChangeNotifier(ValueNotifier(42));
}
