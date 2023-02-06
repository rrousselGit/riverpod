// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../counter/raw.dart';

/* SNIPPET START */

class HomeView extends HookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HookConsumerWidget允许在build方法中使用钩子
    final state = useState(0);

    // 我们也可以使用ref参数来监听provider。
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
