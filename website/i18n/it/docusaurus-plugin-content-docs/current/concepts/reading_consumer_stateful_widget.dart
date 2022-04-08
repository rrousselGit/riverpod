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
    // "ref" può essere usato in tutti i cicli di vita di uno StatefulWidget.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Possiamo anche usare "ref" per ascoltare un provider all'interno del
    // metodo build.
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
