// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
// 一个急切需要初始化的 provider
final exampleProvider = FutureProvider<String>((ref) async => 'Hello world');

class MyConsumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(exampleProvider);

    /// 如果提供者程序被正确的急切初始化了，
    /// 那么我们可以使用 "requireValue" 直接读取数据。
    return Text(result.requireValue);
  }
}
/* SNIPPET END */
