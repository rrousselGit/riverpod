// ignore_for_file: unnecessary_lambdas

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Stream<int> example(Ref ref) {
  final streamController = StreamController<int>();

  ref.onDispose(() {
    // Closes the StreamController when the state of this provider is destroyed.
    streamController.close();
  });

  return streamController.stream;
}
