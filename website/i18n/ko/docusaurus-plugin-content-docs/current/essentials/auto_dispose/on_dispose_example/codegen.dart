// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(OtherRef ref) => 0;

/* SNIPPET START */
@riverpod
Stream<int> example(ExampleRef ref) {
  final controller = StreamController<int>();

  // 상태가 소멸되면 StreamController를 닫습니다.
  ref.onDispose(controller.close);

  // TO-DO: StreamController의 값들을 푸시합니다.
  return controller.stream;
}
/* SNIPPET END */
