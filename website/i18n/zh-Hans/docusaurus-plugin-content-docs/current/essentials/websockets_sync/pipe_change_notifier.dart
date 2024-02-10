// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pipe_change_notifier.g.dart';

/* SNIPPET START */
/// 一个提供者程序，它创建 ValueNotifier 并在值更改时更新其监听器。
@riverpod
ValueNotifier<int> myListenable(MyListenableRef ref) {
  final notifier = ValueNotifier(0);

  // 当提供者程序被处置时处置通知者程序
  ref.onDispose(notifier.dispose);

  // 每当 ValueNotifier 更新时通知此提供者程序的监听器。
  notifier.addListener(ref.notifyListeners);

  return notifier;
}
