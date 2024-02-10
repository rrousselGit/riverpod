import 'dart:math';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
final diceRollProvider = Provider.autoDispose((ref) {
  // 由于此提供者程序是 .autoDispose，因此取消监听将处置其当前公开的状态。
  // 然后，每当再次监听该提供者程序时，就会掷出新的骰子并再次暴露。
  final dice = Random().nextInt(10);
  return dice.isEven;
});

final cachedDiceRollProvider = Provider.autoDispose((ref) {
  final coin = Random().nextInt(10);
  if (coin > 5) throw Exception('Way too large.');
  // 上述条件可能会失败；
  // 如果没有，以下指令会告诉提供者程序保持其缓存状态，即使没有人再监听它。
  ref.keepAlive();
  return coin.isEven;
});
