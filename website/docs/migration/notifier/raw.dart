import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
class DiceNotifier extends Notifier<int> {
  @override
  int build() {
    final random = ref.watch(randomProvider);
    return random + 1;
  }

  void adjust(int offset) => state = state + offset;
}

final diceNotifierProvider = NotifierProvider<DiceNotifier, int>(DiceNotifier.new);
