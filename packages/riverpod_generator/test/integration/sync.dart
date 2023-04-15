import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

/// This is some documentation
@riverpod
String public(PublicRef ref) {
  return 'Hello world';
}

@riverpod
String supports$inNames(Supports$inNamesRef ref) {
  return 'Hello world';
}

/// This is some documentation
@riverpod
String family(
  FamilyRef ref,
  int first, {
  String? second,
  required double third,
  bool fourth = true,
  List<String>? fifth,
}) {
  return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
}

final privateProvider = _privateProvider;

@riverpod
String _private(_PrivateRef ref) {
  return 'Hello world';
}

/// This is some documentation
@riverpod
class PublicClass extends _$PublicClass {
  @override
  String build() {
    return 'Hello world';
  }
}

final privateClassProvider = _privateClassProvider;

@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  String build() {
    return 'Hello world';
  }
}

/// This is some documentation
@riverpod
class FamilyClass extends _$FamilyClass {
  @override
  String build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
  }
}

@riverpod
class Supports$InClassName extends _$Supports$InClassName {
  @override
  String build() {
    return 'Hello world';
  }
}

@riverpod
String generated(GeneratedRef ref) {
  return 'Just a simple normal generated provider';
}

Provider<String> someProvider() => Provider((ref) => 'hello');

// Regression test for https://github.com/rrousselGit/riverpod/issues/2299
final _someProvider = someProvider();

// Regression test for https://github.com/rrousselGit/riverpod/issues/2294
// ignore: unused_element
final _other = _someProvider;
