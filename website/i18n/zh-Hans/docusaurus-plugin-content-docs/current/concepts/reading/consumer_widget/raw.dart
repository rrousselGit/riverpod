import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../counter/raw.dart';

/* SNIPPET START */

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用ref监听provider
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
