// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'counter/raw.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return
/* SNIPPET START */
        Scaffold(
      body: HookConsumer(
        builder: (context, ref, child) {
          // Like HookConsumerWidget, we can use hooks inside the builder
          final state = useState(0);

          // We can also use the ref parameter to listen to providers.
          final counter = ref.watch(counterProvider);
          return Text('$counter');
        },
      ),
    );
/* SNIPPET END */
  }
}
