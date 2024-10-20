import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

@riverpod
Raw<Future<String>> rawFuture(Ref ref) async {
  return 'Hello world';
}

@riverpod
Raw<Stream<String>> rawStream(Ref ref) async* {
  yield 'Hello world';
}

@riverpod
class RawFutureClass extends _$RawFutureClass {
  @override
  Raw<Future<String>> build() async {
    return 'Hello world';
  }
}

@riverpod
class RawStreamClass extends _$RawStreamClass {
  @override
  Raw<Stream<String>> build() async* {
    yield 'Hello world';
  }
}

@riverpod
Raw<Future<String>> rawFamilyFuture(Ref ref, int id) async {
  return 'Hello world';
}

@riverpod
Raw<Stream<String>> rawFamilyStream(Ref ref, int id) async* {
  yield 'Hello world';
}

@riverpod
class RawFamilyFutureClass extends _$RawFamilyFutureClass {
  @override
  Raw<Future<String>> build(int id) async {
    return 'Hello world';
  }
}

@riverpod
class RawFamilyStreamClass extends _$RawFamilyStreamClass {
  @override
  Raw<Stream<String>> build(int id) async* {
    yield 'Hello world';
  }
}

/// This is some documentation
@riverpod
String public(Ref ref) {
  return 'Hello world';
}

@riverpod
String supports$inNames(Ref ref) {
  return 'Hello world';
}

/// This is some documentation
@riverpod
String family(
  Ref ref,
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
String _private(Ref ref) {
  return 'Hello world';
}

/// This is some documentation
@riverpod
class PublicClass extends _$PublicClass {
  PublicClass([this.param]);

  final Object? param;

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
  FamilyClass([this.param]);

  final Object? param;

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
String generated(Ref ref) {
  return 'Just a simple normal generated provider';
}

Provider<String> someProvider() => Provider((ref) => 'hello');

// Regression test for https://github.com/rrousselGit/riverpod/issues/2299
final _someProvider = someProvider();

// Regression test for https://github.com/rrousselGit/riverpod/issues/2294
// ignore: unused_element
final _other = _someProvider;
