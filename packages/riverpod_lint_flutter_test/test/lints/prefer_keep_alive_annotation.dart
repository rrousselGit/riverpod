@TestFor.prefer_keep_alive_annotation
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

part 'prefer_keep_alive_annotation.g.dart';

@riverpod
int first(Ref ref) {
  // ignore: riverpod_lint/prefer_keep_alive_annotation
  ref.keepAlive();

  return 0;
}

@riverpod
class FirstClass extends _$FirstClass {
  @override
  int build() {
    // ignore: riverpod_lint/prefer_keep_alive_annotation
    ref.keepAlive();

    return 0;
  }
}

@Riverpod(keepAlive: true)
int alreadyAnnotated(Ref ref) {
  ref.keepAlive();

  return 0;
}

@riverpod
int conditional(Ref ref, {required bool condition}) {
  if (condition) {
    ref.keepAlive();
  }

  return 0;
}

@riverpod
Future<int> afterAwait(Ref ref) async {
  await Future<void>.value();
  ref.keepAlive();

  return 0;
}

@riverpod
int linkKept(Ref ref) {
  final link = ref.keepAlive();
  ref.onDispose(link.close);

  return 0;
}

@riverpod
int notFirst(Ref ref) {
  ref.onDispose(() {});
  ref.keepAlive();

  return 0;
}

@riverpod
int insideClosure(Ref ref) {
  ref.onCancel(() {
    ref.keepAlive();
  });

  return 0;
}

@riverpod
class NotBuild extends _$NotBuild {
  @override
  int build() => 0;

  void pin() {
    ref.keepAlive();
  }
}

void notAProvider(Ref ref) {
  ref.keepAlive();
}
