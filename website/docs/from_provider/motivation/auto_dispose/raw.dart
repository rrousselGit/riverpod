import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */

final diceRollProvider = Provider.autoDispose((ref) {
  // {@template dice}
  // Since this provider is .autoDispose, un-listening to it will dispose
  // its current exposed state.
  // Then, whenever this provider is listened to again,
  // a new dice will be rolled and exposed again.
  // {@endtemplate}
  final dice = Random().nextInt(10);
  return dice.isEven;
});

final cachedDiceRollProvider = Provider.autoDispose((ref) {
  final coin = Random().nextInt(10);
  if (coin > 5) throw Exception('Way too large.');
  // {@template keepAlive}
  // The above condition might fail;
  // If it doesn't, the following instruction tells the Provider
  // to keep its cached state, even when no one listens to it anymore.
  // {@endtemplate}
  ref.keepAlive();
  return coin.isEven;
});
