import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils.dart';

part 'build_init.g.dart';

Future<void> _startCamera() async {}

/* SNIPPET START */
@riverpod
class DiceNotifier extends _$DiceNotifier {
  @override
  int build() {
    final random = ref.watch(randomProvider);

    print('Post-initialization effects go here.');
    _startCamera();

    return random + 1;
  }

  void adjust(int offset) => state = state + offset;
}
