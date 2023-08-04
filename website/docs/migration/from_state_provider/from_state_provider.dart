import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

/* SNIPPET START */
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;

  @override
  set state(int newState) => super.state = newState;

  int update(int Function(int state) cb) => state = cb(state);
}
