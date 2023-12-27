// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'raw_usage.g.dart';

/* SNIPPET START */
@riverpod
Raw<Stream<int>> rawStream(RawStreamRef ref) {
  // “Raw”是一个 typedef。
  // 无需包装返回值的“原始”构造函数中的值。
  return const Stream<int>.empty();
}

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 该值不再转换为 AsyncValue，
    // 并且按原样返回创建的流。
    Stream<int> stream = ref.watch(rawStreamProvider);
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        return Text('${snapshot.data}');
      },
    );
  }
}
