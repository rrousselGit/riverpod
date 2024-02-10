// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Stream<int> streamExample(StreamExampleRef ref) async* {
  // 1초마다 0에서 41 사이의 숫자를 yield합니다.
  // 이 값은 Firestore나 GraphQL 등의 스트림으로 대체할 수 있습니다.
  for (var i = 0; i < 42; i++) {
    yield i;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 스트림을 수신하고 AsyncValue로 변환합니다.
    AsyncValue<int> value = ref.watch(streamExampleProvider);

    // 로딩/오류 상태를 처리하고 데이터를 표시하는 데 AsyncValue를 사용할 수 있습니다.
    return switch (value) {
      AsyncValue(:final error?) => Text('Error: $error'),
      AsyncValue(:final valueOrNull?) => Text('$valueOrNull'),
      _ => const CircularProgressIndicator(),
    };
  }
}
/* SNIPPET END */
