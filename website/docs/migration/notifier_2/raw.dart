import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
class DiceNotifier extends Notifier<int> {
  @override
  int build() {
    final random = ref.watch(randomProvider);
    return random + 1;
  }

  void adjust(int offset) {
    ref.read(myRepositoryProvider).post(change: offset).ignore();
    state = state + offset;
  }
}
