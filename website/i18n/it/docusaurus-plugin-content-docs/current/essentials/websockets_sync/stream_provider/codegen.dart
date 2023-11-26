// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Stream<int> streamExample(StreamExampleRef ref) async* {
  // Ogni secondo ritorna un numero da 0 a 41.
  // Questo può essere sostituito con uno Stream da Firestore o GraphQL o altro.
  for (var i = 0; i < 42; i++) {
    yield i;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lo stream è ascoltato e convertito in un AsyncValue
    AsyncValue<int> value = ref.watch(streamExampleProvider);

    // Possiamo usare l'AsyncValue per gestire i stati di caricamento/errore e mostrare il dato.
    return switch (value) {
      AsyncValue(:final error?) => Text('Error: $error'),
      AsyncValue(:final valueOrNull?) => Text('$valueOrNull'),
      _ => const CircularProgressIndicator(),
    };
  }
}
/* SNIPPET END */