// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends HookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HookConsumerWidget 可允许我们在 build 方法内使用 hooks
    final state = useState(0);

    // 同时，我们也可以使用 `ref` 去监听 provider
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
