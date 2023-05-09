// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 我们创建一个 provider，它将用于保存一个值（这里是 Hello world）
// 通过使用一个 provider，我们能够模拟或覆盖被暴露的值
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // 为了能让组件读取 provider，我们需要将整个应用都包裹在 ProviderScope 组件内
    // 这里也就是存储我们所有 provider 状态的地方
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// 扩展来自 Riverpod 的 HookConsumerWidget 而不是 HookWidget
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 我们可以在 HookConsumerWidget 中使用钩子
    final counter = useState(0);

    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text('$value ${counter.value}'),
        ),
      ),
    );
  }
}
