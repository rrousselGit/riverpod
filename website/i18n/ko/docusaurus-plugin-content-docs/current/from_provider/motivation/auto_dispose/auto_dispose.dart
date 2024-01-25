import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

/* SNIPPET START */

// 코드 생성 시 .autoDispose가 기본값
@riverpod
int diceRoll(DiceRollRef ref) {
  // 이 provider는 .autoDispose이므로
  // 리스닝을 해제하면 현재 노출된 상태가 폐기됩니다.
  // 그런 다음 이 provider를 다시 수신할 때마다
  // 새로운 주사위를 굴려서 다시 노출합니다.
  final dice = Random().nextInt(10);
  return dice;
}

@riverpod
int cachedDiceRoll(CachedDiceRollRef ref) {
  final coin = Random().nextInt(10);
  if (coin > 5) throw Exception('Way too large.');
  // 위의 조건은 실패할 수 있습니다;
  // 그렇지 않은 경우, 다음 명령어는 아무도 더 이상 수신하지 않더라도
  // 캐시된 상태를 유지하도록 provider에게 지시합니다.
  ref.keepAlive();
  return coin;
}
