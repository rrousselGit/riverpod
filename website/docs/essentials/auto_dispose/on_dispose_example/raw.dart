// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final provider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();

  // When the state is destroyed, we close the StreamController.
  ref.onDispose(controller.close);

  // TO-DO: Push some values in the StreamController
  return controller.stream;
});
/* SNIPPET END */
