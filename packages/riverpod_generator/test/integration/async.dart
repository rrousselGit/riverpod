// ignore_for_file: omit_local_variable_types, prefer_final_locals, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async.g.dart';

@riverpod
FutureOr<String> public(PublicRef ref) {
  return 'Hello world';
}

const privateProvider = _PrivateProvider;

@riverpod
Future<String> _private(_PrivateRef ref) async {
  return 'Hello world';
}

@riverpod
FutureOr<String> family(
  FamilyRef ref,
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
  return '(first: $first, second: $second, third: $third, forth: $forth, fifth: $fifth)';
}

@riverpod
class PublicClass extends _$PublicClass {
  @override
  FutureOr<String> build() {
    return 'Hello world';
  }
}

const privateClassProvider = _PrivateClassProvider;

@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  Future<String> build() async {
    return 'Hello world';
  }
}

@riverpod
class FamilyClass extends _$FamilyClass {
  @override
  FutureOr<String> build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    return '(first: $first, second: $second, third: $third, forth: $forth, fifth: $fifth)';
  }
}
