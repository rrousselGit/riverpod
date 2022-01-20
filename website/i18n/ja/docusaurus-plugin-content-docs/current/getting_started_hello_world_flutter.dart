// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 値（ここでは "Hello world"）を格納する「プロバイダ」を作成します。
// プロバイダを使うことで値のモックやオーバーライドが可能になります。
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // プロバイダをウィジェットで利用するには、アプリ全体を
    // `ProviderScope` ウィジェットで囲む必要があります。
    // ここに各プロバイダのステート（状態）・値が格納されていきます。
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// StatelessWidget の代わりに Riverpod の ConsumerWidget を継承します。
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
