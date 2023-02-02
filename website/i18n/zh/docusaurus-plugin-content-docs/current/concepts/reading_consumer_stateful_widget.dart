import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends ConsumerStatefulWidget {
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
    // 在此 build 方法内，我们同样能够使用 `ref` 去监听 provider
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
