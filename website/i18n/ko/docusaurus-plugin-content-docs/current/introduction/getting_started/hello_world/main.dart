// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// 값을 저장할 “provider"를 생성합니다(여기서는 "Hello world").
// 프로바이더를 사용하면, 노출된 값을 모의(Mock)하거나 재정의(Override)할 수 있습니다.
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  runApp(
    // 위젯이 프로바이더를 읽을 수 있도록 하려면,
    // 전체 애플리케이션을 "ProviderScope" 위젯으로 감싸야 합니다.
    // 여기에 프로바이더의 상태가 저장됩니다.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// StatelessWidget 대신 Riverpod에서 제공되는 ConsumerWidget을 확장합니다.
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
