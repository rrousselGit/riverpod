import 'dart:math';

import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

final diceRollProvider = Provider.autoDispose((ref) {
  // Poiché questo provider è .autoDispose, smettere di ascoltarlo ne disporrà lo stato esposto attuale.
  // Quindi, ogni volta che questo provider viene ascoltato di nuovo,
  // verrà tirato un nuovo dado e lo stato verrà esposto di nuovo.
  final dice = Random().nextInt(10);
  return dice.isEven;
});

final cachedDiceRollProvider = Provider.autoDispose((ref) {
  final coin = Random().nextInt(10);
  if (coin > 5) throw Exception('Way too large.');
  // La condizione sopra potrebbe fallire;
  // Se non lo fa, l'istruzione seguente dice al Provider
  // di mantenere il suo stato in cache, *anche quando nessuno lo ascolta più*.
  ref.keepAlive();
  return coin.isEven;
});
