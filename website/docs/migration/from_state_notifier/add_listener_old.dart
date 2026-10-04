
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_ui/material_ui.dart';

/* SNIPPET START */
class MyNotifier extends StateNotifier<int> {
  MyNotifier() : super(0);

  void add() => state++;
}

final myNotifierProvider = StateNotifierProvider<MyNotifier, int>((ref) {
  final notifier = MyNotifier();

  final cleanup = notifier.addListener((state) => debugPrint('$state'));
  ref.onDispose(cleanup);

  // {@template listener}
  // Or, equivalently:
  // {@endtemplate}
  // final listener = notifier.stream.listen((event) => debugPrint('$event'));
  // ref.onDispose(listener.cancel);

  return notifier;
});
