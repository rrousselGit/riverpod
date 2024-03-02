// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todos.dart';

/* SNIPPET START */

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // উইজেট রিবিল্ট হবে যখন টুডু লিস্ট চ্যাঞ্জ হবে
    List<Todo> todos = ref.watch(todosProvider);

    // আসুন একটি স্ক্রোলযোগ্য ListView-তে todos রেন্ডার করি
    return ListView(
      children: [
        for (final todo in todos)
          CheckboxListTile(
            value: todo.completed,
            // টোডোতে ট্যাপ করার সময়, এর স্টেট পরিবর্তন করুন কমপ্লিট স্ট্যাটাস এ
            onChanged: (value) =>
                ref.read(todosProvider.notifier).toggle(todo.id),
            title: Text(todo.description),
          ),
      ],
    );
  }
}
