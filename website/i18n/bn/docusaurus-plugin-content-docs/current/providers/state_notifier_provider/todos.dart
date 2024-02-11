import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */

// আমাদের স্টেট নোটিফায়ারের অবস্থা অপরিবর্তনীয় হওয়া উচিত।
// বাস্তবায়নে সাহায্য করার জন্য আমরা Freezed-এর মতো প্যাকেজগুলিও ব্যবহার করতে পারি।
@immutable
class Todo {
  const Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  // সমস্ত বৈশিষ্ট্য আমাদের ক্লাসে 'final' হওয়া উচিত।
  final String id;
  final String description;
  final bool completed;

  // যেহেতু টোডো অপরিবর্তনীয়, আমরা একটি পদ্ধতি প্রয়োগ করি যা সামান্য ভিন্ন বিষয়বস্তু সহ
  // টোডো ক্লোন করার অনুমতি দেয়।
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// StateNotifier ক্লাস যা আমাদের StateNotifierProvider-এ পাস করা হবে। এই ক্লাসটি তার
//"ষ্টেট" প্রপার্টির বাইরে ষ্টেটকে প্রকাশ করা উচিত নয়, যার মানে কোনও পাবলিক গেটার/প্রপার্টি নেই! এই ক্লাস
// সর্বজনীন মেথদগুলিই হবে যা UI-কে ষ্টেট সংশোধন করতে দেয়৷
class TodosNotifier extends StateNotifier<List<Todo>> {
  // আমরা একটি খালি তালিকায় todos তালিকা শুরু করি
  TodosNotifier() : super([]);

  // আর UI কে todos যোগ করার অনুমতি দেওয়া যাক।
  void addTodo(Todo todo) {
    // যেহেতু আমাদের ষ্টেট অপরিবর্তনীয়, তাই আমাদের `state.add(todo)` করার অনুমতি নেই।
    // পরিবর্তে, আমাদের টোডোর একটি নতুন তালিকা তৈরি করা উচিত যাতে পূর্ববর্তী আইটেম এবং
    // নতুনটি রয়েছে।
    // এখানে ডার্টের স্প্রেড অপারেটর ব্যবহার করা সহায়ক!
    state = [...state, todo];
    // "notifyListeners" বা অনুরূপ কিছু কল করার প্রয়োজন নেই।
    // "state = " কল করলে প্রয়োজনে স্বয়ংক্রিয়ভাবে UI পুনর্নির্মাণ করবে।
  }

  // এর টোডো অপসারণের অনুমতি দেওয়া যাক
  void removeTodo(String todoId) {
    // আবার, আমাদের ষ্টেট অপরিবর্তনীয়। তাই আমরা বিদ্যমান তালিকা পরিবর্তনের পরিবর্তে
    // একটি নতুন তালিকা তৈরি করছি।
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // আসুন একটি করণীয়কে সম্পূর্ণ হিসাবে চিহ্নিত করি
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // আমরা শুধুমাত্র মিলে যাওয়া করণীয়কে সম্পূর্ণ হিসেবে চিহ্নিত করছি
        if (todo.id == todoId)
          // আরও একবার, যেহেতু আমাদের ষ্টেট অপরিবর্তনীয়, তাই আমাদের একটি কপি তৈরি করতে হবে
          // এই টুডুটার. এটিতে সহায়তা করার জন্য আমরা আগে প্রয়োগ করা
          // আমাদের `copyWith` মেথড ব্যবহার করছি
          todo.copyWith(completed: !todo.completed)
        else
          // অন্যান্য todos সংশোধন করা হয় না
          todo,
    ];
  }
}

// অবশেষে, আমরা UI কে আমাদের TodosNotifier ক্লাসের সাথে ইন্টারঅ্যাক্ট করার
// অনুমতি দিতে StateNotifierProvider ব্যবহার করছি।
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
