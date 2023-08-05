import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils.dart';

part 'family_and_dispose.g.dart';

/* SNIPPET START */
@riverpod
class DiceNotifier extends _$DiceNotifier {
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
