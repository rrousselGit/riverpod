import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

@Riverpod(keepAlive: true)
int keepAlive(KeepAliveRef ref) {
  return 0;
}

@Riverpod(keepAlive: false)
int notKeepAlive(NotKeepAliveRef ref) {
  ref.keepAlive();
  return 0;
}
