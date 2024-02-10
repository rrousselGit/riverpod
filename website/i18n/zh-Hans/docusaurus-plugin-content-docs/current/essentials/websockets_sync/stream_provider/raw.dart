// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final streamExampleProvider = StreamProvider.autoDispose<int>((ref) async* {
  // 每 1 秒产生一个 0 到 41 之间的数字。
  // 这可以替换为来自 Firestore 或 GraphQL 或其他任何东西的 Stream。
  for (var i = 0; i < 42; i++) {
    yield i;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
});

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 该流被监听并转换为 AsyncValue。
    AsyncValue<int> value = ref.watch(streamExampleProvider);

    // 我们可以使用 AsyncValue 来处理加载/错误状态并显示数据。
    return switch (value) {
      AsyncValue(:final error?) => Text('Error: $error'),
      AsyncValue(:final valueOrNull?) => Text('$valueOrNull'),
      _ => const CircularProgressIndicator(),
    };
  }
}
/* SNIPPET END */
