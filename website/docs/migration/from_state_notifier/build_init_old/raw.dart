import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state++;
}

final wellNotifierProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});
