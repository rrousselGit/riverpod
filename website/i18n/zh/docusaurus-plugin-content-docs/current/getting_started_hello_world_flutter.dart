// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 创建一个存储值（此值为 “Hello world”）的 provider。
// 通过使用 provider 可对值进行模拟或覆盖。
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // ProviderScope 是个存储 providers 状态的组件。
    // 要在应用程序内使用或读取该 providers，必须用 ProviderScope 包装 MyApp。
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// 把继承 StatelessWidget 更改为继承 Riverpod 的 ConsumerWidget。
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}
