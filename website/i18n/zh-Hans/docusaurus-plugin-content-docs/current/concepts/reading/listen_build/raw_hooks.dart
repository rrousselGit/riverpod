// ignore_for_file: omit_local_variable_types, avoid_types_on_closure_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../counter/raw.dart';

/* SNIPPET START */

final counterProvider =
    StateNotifierProvider<Counter, int>(Counter.new);

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int>(counterProvider, (int? previousCount, int newCount) {
      print('The counter changed $newCount');
    });

    final greeting = useState('Hello');

    return Container(
      alignment: Alignment.center,
      child: Text(greeting.value),
    );
  }
}
