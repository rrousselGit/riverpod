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

@riverpod
int defaultKeepAlive(DefaultKeepAliveRef ref) {
  return 0;
}

@Riverpod(keepAlive: true)
int keepAliveFamily(KeepAliveFamilyRef ref, int a) {
  return 0;
}

@Riverpod(keepAlive: false)
int notKeepAliveFamily(NotKeepAliveFamilyRef ref, int a) {
  ref.keepAlive();
  return 0;
}

@riverpod
int defaultKeepAliveFamily(DefaultKeepAliveFamilyRef ref, int a) {
  return 0;
}
