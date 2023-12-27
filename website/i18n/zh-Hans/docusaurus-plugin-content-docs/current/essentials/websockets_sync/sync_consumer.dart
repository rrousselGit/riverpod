// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_definition/raw.dart';

void main() {
/* SNIPPET START */
  Consumer(
    builder: (context, ref, child) {
      // value 没有使用 "AsyncValue "包装
      int value = ref.watch(synchronousExampleProvider);

      return Text('$value');
    },
  );
/* SNIPPET END */
}
