// ignore_for_file: omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'raw_usage.g.dart';

/* SNIPPET START */
@riverpod
Raw<Stream<int>> rawStream(RawStreamRef ref) {
  // "Raw"는 typedef입니다. "Raw" 생성자로 반환값을 Wrap할 필요가 없습니다.
  return const Stream<int>.empty();
}

class Consumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 값이 더 이상 AsyncValue로 변환되지 않고, 생성된 스트림이 그대로 반환됩니다.
    Stream<int> stream = ref.watch(rawStreamProvider);
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        return Text('${snapshot.data}');
      },
    );
  }
}
