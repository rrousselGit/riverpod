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

  // When the state is destroyed, we close the StreamController.
  ref.onDispose(controller.close);

  // TO-DO: Push some values in the StreamController
  return controller.stream;
}
/* SNIPPET END */
