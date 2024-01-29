import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  @override
  set state(int newState) => super.state = newState;
  int update(int Function(int state) cb) => state = cb(state);
}

final counterNotifierProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);
