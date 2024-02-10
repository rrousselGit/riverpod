// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final myProvider = ChangeNotifierProvider<ValueNotifier<int>>((ref) {
  // ValueNotifier를 수신하고 처리합니다.
  // 그러면 위젯은 이 provider를 "ref.watch"하여 업데이트를 수신할 수 있습니다.
  return ValueNotifier(0);
});
