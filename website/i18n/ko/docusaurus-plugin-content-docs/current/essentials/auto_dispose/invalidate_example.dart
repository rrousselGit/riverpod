// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 자동 상태 소멸을 활성화하려면 autoDispose를 지정할 수 있습니다.
final someProvider = Provider.autoDispose<int>((ref) {
  return 0;
});

/* SNIPPET START */
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // 클릭 시 공급자를 삭제합니다.
        ref.invalidate(someProvider);
      },
      child: const Text('dispose a provider'),
    );
  }
}
