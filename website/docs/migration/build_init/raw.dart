import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils.dart';

Future<void> _startCamera() async {}

/* SNIPPET START */
class DiceNotifier extends Notifier<int> {
  @override
  int build() {
    final random = ref.watch(randomProvider);

    print('Post-initialization effects go here.');
    _startCamera();

    return random + 1;
  }

  void adjust(int offset) => state = state + offset;
}

final diceNotifierProvider = NotifierProvider<DiceNotifier, int>(DiceNotifier.new);
