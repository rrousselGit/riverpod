import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

@Riverpod(keepAlive: true)
int keepAlive(Ref ref) {
  return 0;
}

@Riverpod(keepAlive: false)
int notKeepAlive(Ref ref) {
  ref.keepAlive();
  return 0;
}

@riverpod
int defaultKeepAlive(Ref ref) {
  return 0;
}

@Riverpod(keepAlive: true)
int keepAliveFamily(Ref ref, int a) {
  return 0;
}

@Riverpod(keepAlive: false)
int notKeepAliveFamily(Ref ref, int a) {
  ref.keepAlive();
  return 0;
}

@riverpod
int defaultKeepAliveFamily(Ref ref, int a) {
  return 0;
}
