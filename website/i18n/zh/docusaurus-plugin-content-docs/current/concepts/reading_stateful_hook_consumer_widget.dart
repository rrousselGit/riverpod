// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends StatefulHookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    // 可在 StatefulWidget 的生命周期内使用 `ref`
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // 与 HookConsumerWidget 同样，可允许我们在 build 方法内使用 hooks
    final state = useState(0);

    // 同时也允许我们使用 `ref` 去监听 provider
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
