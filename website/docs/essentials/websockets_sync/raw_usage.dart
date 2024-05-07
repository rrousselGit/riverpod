// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'raw_usage.g.dart';

/* SNIPPET START */
@riverpod
Raw<Stream<int>> rawStream(RawStreamRef ref) {
  // {@template provider}
  // "Raw" is a typedef. No need to wrap the return
  // value in a "Raw" constructor.
  // {@endtemplate}
  return const Stream<int>.empty();
}

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // {@template watch}
    // The value is no-longer converted to AsyncValue,
    // and the created stream is returned as is.
    // {@endtemplate}
    Stream<int> stream = ref.watch(rawStreamProvider);
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        return Text('${snapshot.data}');
      },
    );
  }
}
