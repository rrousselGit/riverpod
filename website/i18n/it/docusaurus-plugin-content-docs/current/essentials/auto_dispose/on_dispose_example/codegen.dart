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

  // Quando lo stato viene distrutto chiudiamo lo StreamController.
  ref.onDispose(controller.close);

  // TO-DO: Aggiungere dei valori nello StreamController
  return controller.stream;
}
/* SNIPPET END */
