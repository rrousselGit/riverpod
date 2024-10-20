import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async.g.dart';

@riverpod
FutureOr<String> public(Ref ref) {
  return 'Hello world';
}

final privateProvider = _privateProvider;

@riverpod
Future<String> _private(Ref ref) async {
  return 'Hello world';
}

@riverpod
FutureOr<String> familyOr(Ref ref, int first) {
  return '(first: $first)';
}

@riverpod
Future<String> family(
  Ref ref,
  int first, {
  String? second,
  required double third,
  bool fourth = true,
  List<String>? fifth,
}) async {
  return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
}

@riverpod
class PublicClass extends _$PublicClass {
  PublicClass([this.param]);

  final Object? param;

  @override
  FutureOr<String> build() {
    return 'Hello world';
  }
}

final privateClassProvider = _privateClassProvider;

@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  Future<String> build() async {
    return 'Hello world';
  }
}

@riverpod
class FamilyOrClass extends _$FamilyOrClass {
  @override
  FutureOr<String> build(int first) {
    return '(first: $first)';
  }
}

@riverpod
class FamilyClass extends _$FamilyClass {
  FamilyClass([this.param]);

  final Object? param;

  @override
  Future<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) async {
    return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
  }
}
