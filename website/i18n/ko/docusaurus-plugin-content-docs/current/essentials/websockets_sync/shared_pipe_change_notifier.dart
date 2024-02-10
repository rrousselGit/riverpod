// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_pipe_change_notifier.g.dart';

/* SNIPPET START */
extension on Ref<Object?> {
  // 이전 로직을 Ref 확장(extension)으로 옮길 수 있습니다.
  // 이렇게 하면 provider 간에 로직을 재사용할 수 있습니다.
  T disposeAndListenChangeNotifier<T extends ChangeNotifier>(T notifier) {
    onDispose(notifier.dispose);
    notifier.addListener(notifyListeners);
    // 사용 편의성을 높이기 위해 Notifier을 반환합니다.
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
