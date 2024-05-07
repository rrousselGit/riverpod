import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

/* SNIPPET START */

// {@template codegen_autoDispose}
// With code gen, .autoDispose is the default
// {@endtemplate}
@riverpod
int diceRoll(DiceRollRef ref) {
  // {@template dice}
  // Since this provider is .autoDispose, un-listening to it will dispose
  // its current exposed state.
  // Then, whenever this provider is listened to again,
  // a new dice will be rolled and exposed again.
  // {@endtemplate}
  final dice = Random().nextInt(10);
  return dice;
}

@riverpod
int cachedDiceRoll(CachedDiceRollRef ref) {
  final coin = Random().nextInt(10);
  if (coin > 5) throw Exception('Way too large.');
  // {@template keepAlive}
  // The above condition might fail;
  // If it doesn't, the following instruction tells the Provider
  // to keep its cached state, even when no one listens to it anymore.
  // {@endtemplate}
  ref.keepAlive();
  return coin;
}
