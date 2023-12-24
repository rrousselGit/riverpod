// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'raw_usage.g.dart';

/* SNIPPET START */
@riverpod
Raw<Stream<int>> rawStream(RawStreamRef ref) {
  // "Raw" è un typedef. Non c'è bisogno di wrappare
  // il valore di ritorno in un costruttore "Raw".
  return const Stream<int>.empty();
}

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Il valore non è più convertito in AsyncValue
    // e lo stream creato è ritornato come tale.
    Stream<int> stream = ref.watch(rawStreamProvider);
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        return Text('${snapshot.data}');
      },
    );
  }
}
