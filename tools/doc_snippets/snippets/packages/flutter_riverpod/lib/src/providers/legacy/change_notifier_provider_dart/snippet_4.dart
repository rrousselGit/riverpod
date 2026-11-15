// GENERATED from packages/flutter_riverpod/lib/src/providers/legacy/change_notifier_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_ui/material_ui.dart';

late WidgetRef ref;

class Todo {
  Todo(this.id, this.description);
  final String id;
  final String description;
  bool completed = false;
}

class Counter extends ChangeNotifier {
  int count = 0;
  void increment() {
    count++;
    notifyListeners();
  }
}

final changeNotifierProvider = ChangeNotifierProvider((ref) => Counter());

dynamic snippet() async => ElevatedButton(
  onPressed: () => ref.read(changeNotifierProvider.notifier).increment(),
  child: Text('Increment'),
);
