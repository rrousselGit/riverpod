import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    //  `ref` は StatefulWidget のすべてのライフサイクルメソッド内で使用可能です。
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    //  `ref` は build メソッド内で使用することもできます。
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}