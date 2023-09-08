// ignore_for_file: avoid_print, avoid_unused_constructor_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  const Todo(this.id);
  Todo.fromJson(Object obj) : id = 0;

  final int id;
}

class Http {
  Future<List<Object>> get(String str) async => [str];
  Future<List<Object>> post(String str) async => [str];
}

final http = Http();

/* SNIPPET START */
class MyChangeNotifier extends ChangeNotifier {
  MyChangeNotifier() {
    _init();
  }
  List<Todo> todos = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> _init() async {
    try {
      final json = await http.get('api/todos');
      todos = [...json.map(Todo.fromJson)];
    } on Exception {
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final json = await http.post('api/todos');
      todos = [...json.map(Todo.fromJson)];
      hasError = false;
    } on Exception {
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

final myChangeProvider = ChangeNotifierProvider<MyChangeNotifier>((ref) {
  return MyChangeNotifier();
});
