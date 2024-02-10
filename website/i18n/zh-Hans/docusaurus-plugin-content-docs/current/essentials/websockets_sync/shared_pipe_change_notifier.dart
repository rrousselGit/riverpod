// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_pipe_change_notifier.g.dart';

/* SNIPPET START */
extension on Ref<Object?> {
  // 我们可以将之前的逻辑移至 Ref 扩展。
  // 这使得能够重用提供者程序之间的逻辑
  T disposeAndListenChangeNotifier<T extends ChangeNotifier>(T notifier) {
    onDispose(notifier.dispose);
    notifier.addListener(notifyListeners);
    // 我们返回通知者程序以稍微简化使用
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
