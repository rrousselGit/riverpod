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
    // "ref" peut être utilisé dans tous les cycles de vie d'un StatefulWidget.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Comme HookConsumerWidget, nous pouvons utiliser des hooks à l'intérieur du constructeur.
    final state = useState(0);

    // Nous pouvons également utiliser "ref" pour écouter un provider dans la méthode build.
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}