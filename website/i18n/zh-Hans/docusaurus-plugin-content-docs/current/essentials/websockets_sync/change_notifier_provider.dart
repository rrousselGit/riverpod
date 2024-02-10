// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */
final myProvider = ChangeNotifierProvider<ValueNotifier<int>>((ref) {
  // 将监听并处置 ValueNotifier。
  // 然后，小部件可以使用 "ref.watch" 对提供者程序监听更新。
  return ValueNotifier(0);
});
