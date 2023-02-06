import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../counter/raw.dart';

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
    // “ref” 可以在 StatefulWidget 的所有的生命周期内使用。
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // 我们也可以在build函数中使用“ref”监听provider
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
