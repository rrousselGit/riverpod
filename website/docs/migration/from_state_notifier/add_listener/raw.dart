
import 'package:material_ui/material_ui.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  @override
  int build() {
    listenSelf((_, next) => debugPrint('$next'));
    return 0;
  }

  void add() => state++;
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
