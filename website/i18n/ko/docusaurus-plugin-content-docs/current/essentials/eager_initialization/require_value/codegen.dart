// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
// 이른 초기화된 provider
@riverpod
Future<String> example(ExampleRef ref) async => 'Hello world';

class MyConsumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(exampleProvider);

    /// provider가 올바르게 초기화되었다면,
    /// "requireValue"로 데이터를 직접 읽을 수 있습니다.
    return Text(result.requireValue);
  }
}
/* SNIPPET END */
