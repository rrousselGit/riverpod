import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hash1.g.dart';

@riverpod
String simple(Ref ref) {
  return 'Hello world';
}

@riverpod
String simple2(Ref ref) {
  return 'Hello world2';
}

@riverpod
class SimpleClass extends _$SimpleClass {
  @override
  String build() => 'Hello world';
}
