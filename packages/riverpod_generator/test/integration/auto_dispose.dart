import 'package:riverpod/riverpod.dart';
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
