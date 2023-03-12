// ignore_for_file: omit_local_variable_types, avoid_types_on_closure_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_hooks.g.dart';

enum FilterType {
  none,
  completed,
}

abstract class Todo {
  bool get isCompleted;
}

@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];
}

/* SNIPPET START */

@riverpod
int counter(CounterRef ref) => 0;

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can use hooks inside a HookConsumerWidget
    final greeting = useState('Hello');

    // use ref to listen to a provider
    final counter = ref.watch(counterProvider);

    return Text('${greeting.value} $counter');
  }
}
