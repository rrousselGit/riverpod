import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

/* SNIPPET START */
@riverpod
class DiceNotifier extends _$DiceNotifier {
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
