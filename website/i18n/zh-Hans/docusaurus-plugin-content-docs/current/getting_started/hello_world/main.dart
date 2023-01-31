// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// 我们创建了一个 "provider", 这里它存储了一个值 (这里是 "Hello world")。
// 通过使用provider，我们能够重写或模拟这个暴露的值
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  runApp(
    // 为了让widget能够读取到provider，我们需要在整个应用外面套上一个
    // 名为 "ProviderScope"的widget。
    // 我们的这些provider会在这里保存。
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// 这里我们使用Rivderpod提供的 "ConsumerWidget" 而不是flutter自带的 "StatelessWidget"。
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
