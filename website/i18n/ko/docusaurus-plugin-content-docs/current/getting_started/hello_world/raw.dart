// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 우리는 값을 저장할 "provider"를 만들겁니다(여기서 값은 "Hello world"를 의미합니다).
// 프로바이더를 사용하는 것으로 값의 mock/override가 가능하게 됩니다.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // 위젯에서 프로바이더를 사용하고 읽기위해
    // 앱 전체적으로 "ProviderScope" 위젯을 감싸줘야 합니다.
    // 여기에 프로바이더의 상태가 저장됩니다.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// StatelessWidget 대신에 Riverpod의 ConsumerWidget을 상속받아 사용합니다.
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
