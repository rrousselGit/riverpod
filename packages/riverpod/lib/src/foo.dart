import 'dart:async';

import 'notifier.dart';

final counterProvider = AsyncNotifierProvider<Counter, int>(() => Counter());

class Counter extends AsyncNotifier<int> {
  @override
  FutureOr<int> init() {
    // TODO: implement init
    throw UnimplementedError();
  }
}
