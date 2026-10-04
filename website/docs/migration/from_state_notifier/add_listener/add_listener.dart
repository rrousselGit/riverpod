
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_listener.g.dart';

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() {
    listenSelf((_, next) => debugPrint('$next'));
    return 0;
  }

  void add() => state++;
}
