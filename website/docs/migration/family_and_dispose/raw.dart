import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils.dart';

/* SNIPPET START */
class DiceNotifier extends FamilyNotifier<int, String> {
  late String _id;
  @override
  int build(String arg) {
    final random = ref.watch(randomProvider);
    _id = arg;
    return random + 1;
  }

  void adjust(int offset) {
    ref.read(myRepositoryProvider).post(id: _id, change: offset).ignore();
    state = state + offset;
  }
}

final diceNotifierProvider = NotifierProviderFamily<DiceNotifier, int, String>(DiceNotifier.new);
