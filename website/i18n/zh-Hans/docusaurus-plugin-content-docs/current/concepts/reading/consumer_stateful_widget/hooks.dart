// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../counter/raw.dart';

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
    // “ref” 可以在 StatefulWidget 的所有的生命周期内使用。
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // 我们可以在builder中使用钩子如同HookConsumerWidget使用的那样
    final state = useState(0);

    // 我们也可以在build函数中使用“ref”监听provider
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
