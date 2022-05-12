import 'dart:async';

import '../riverpod.dart';

final counterProvider =
    NotifierProviderFamily<Counter, int, String>(() => Counter());

class Counter extends NotifierFamily<int, String> {
  @override
  int init(String param) {
    // TODO: implement init
    throw UnimplementedError();
  }
}
