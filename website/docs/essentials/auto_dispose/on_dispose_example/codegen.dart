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

  // {@template onDispose}
  // When the state is destroyed, we close the StreamController.
  // {@endtemplate}
  ref.onDispose(controller.close);

  // {@template todo}
  // TO-DO: Push some values in the StreamController
  // {@endtemplate}
  return controller.stream;
}
/* SNIPPET END */
