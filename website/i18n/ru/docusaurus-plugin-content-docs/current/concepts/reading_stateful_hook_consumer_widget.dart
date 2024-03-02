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
    // "ref" можно использовать внутри каждого метода жизненного цикла StatefulWidget.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Мы можем использовать хуки внутри builder, как и в HookConsumerWidget
    final state = useState(0);

    // Также мы можем использовать ref внутри метода build 
    // для прослушивания провайдеров.
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
