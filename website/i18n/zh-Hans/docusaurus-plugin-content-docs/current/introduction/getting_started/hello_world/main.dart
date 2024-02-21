// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types, unreachable_from_main

/* SNIPPET START */ import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// 我们创建了一个 "provider"，它可以存储一个值（这里是 "Hello world"）。
// 通过使用提供者程序，这可以允许我们模拟或者覆盖一个暴露的值。
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  runApp(
    // 为了使小组件可以读取提供者程序，
    // 我们需要将整个应用程序包装在“ProviderScope”小部件中。
    // 这是我们的提供者程序的状态将被存储的地方。
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// 继承父类使用 ConsumerWidget 替代 StatelessWidget，这样可以获取到提供者程序的引用
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
