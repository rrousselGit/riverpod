import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../counter/raw.dart';

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
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // We can also use "ref" to listen to a provider inside the build method
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
