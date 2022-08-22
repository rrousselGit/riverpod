import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

@Riverpod(cacheTime: 10, disposeDelay: 20)
int timers(TimersRef ref) {
  ref.keepAlive();
  return 0;
}

@Riverpod(cacheTime: 12, disposeDelay: 21)
int timers2(Timers2Ref ref, int a) {
  ref.keepAlive();
  return 0;
}

@Riverpod(keepAlive: true)
int keepAlive(KeepAliveRef ref) {
  return 0;
}

@Riverpod(keepAlive: false)
int notKeepAlive(NotKeepAliveRef ref) {
  ref.keepAlive();
  return 0;
}
