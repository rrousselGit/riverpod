// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reading_counter.dart';

/* SNIPPET START */

final counterProvider =
    StateNotifierProvider<Counter, int>((ref) => Counter(ref));

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // `Counter`클래스의 increment() 메소드를 호출합니다.
          ref.read(counterProvider.notifier).increment();
        },
      ),
    );
  }
}
