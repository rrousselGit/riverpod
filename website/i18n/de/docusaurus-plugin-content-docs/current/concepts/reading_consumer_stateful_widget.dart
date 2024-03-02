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
    // "ref" kann in allen Lebenszyklen eines StatefulWidget verwendet werden.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Wir können auch "ref" verwenden, um einen Provider innerhalb der Build-Methode abzuhören
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
