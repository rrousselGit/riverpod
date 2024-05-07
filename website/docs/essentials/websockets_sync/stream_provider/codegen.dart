// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Stream<int> streamExample(StreamExampleRef ref) async* {
  // {@template provider}
  // Every 1 second, yield a number from 0 to 41.
  // This could be replaced with a Stream from Firestore or GraphQL or anything else.
  // {@endtemplate}
  for (var i = 0; i < 42; i++) {
    yield i;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // {@template watch}
    // The stream is listened to and converted to an AsyncValue.
    // {@endtemplate}
    AsyncValue<int> value = ref.watch(streamExampleProvider);

    // {@template consumer}
    // We can use the AsyncValue to handle loading/error states and show the data.
    // {@endtemplate}
    return switch (value) {
      AsyncValue(:final error?) => Text('Error: $error'),
      AsyncValue(:final valueOrNull?) => Text('$valueOrNull'),
      _ => const CircularProgressIndicator(),
    };
  }
}
/* SNIPPET END */