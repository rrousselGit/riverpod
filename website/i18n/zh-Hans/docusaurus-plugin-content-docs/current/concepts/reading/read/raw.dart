// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../counter/raw.dart';

/* SNIPPET START */

final counterProvider =
    StateNotifierProvider<Counter, int>(Counter.new);

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 对“Counter”类调用“increment()”方法
          ref.read(counterProvider.notifier).increment();
        },
      ),
    );
  }
}
