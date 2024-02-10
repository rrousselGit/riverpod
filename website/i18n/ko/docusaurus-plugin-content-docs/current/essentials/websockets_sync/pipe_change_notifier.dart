// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pipe_change_notifier.g.dart';

/* SNIPPET START */
/// 값이 변경될 때마다 ValueNotifier를 생성하고 리스너를 업데이트하는 provider입니다.
@riverpod
ValueNotifier<int> myListenable(MyListenableRef ref) {
  final notifier = ValueNotifier(0);

  // provider가 dispose되면 notifier를 dispose합니다.
  ref.onDispose(notifier.dispose);

  // ValueNotifier가 업데이트될 때마다 이 provider의 리스너에게 알립니다.
  notifier.addListener(ref.notifyListeners);

  return notifier;
}
