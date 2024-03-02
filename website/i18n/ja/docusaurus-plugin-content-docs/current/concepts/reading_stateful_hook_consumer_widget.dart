// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends StatefulHookConsumerWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    // 「ref」は StatefulWidget のすべてのライフサイクルメソッド内で使用できます。
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // HookConsumerWidget のように build メソッドの中でフックが使えます。
    final state = useState(0);

    // プロバイダ監視のために「ref」を使用することも可能です。
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
