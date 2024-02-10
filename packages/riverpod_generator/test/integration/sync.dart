import 'package:riverpod/riverpod.dart' as r;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

@riverpod
List<T> generic<T extends num>(GenericRef<T> ref) {
  return <Object?>[
    'Hello world',
    42,
    3.14,
  ].whereType<T>().toList();
}

@riverpod
List<T> complexGeneric<T extends num, Foo extends String?>(
  ComplexGenericRef<T, Foo> ref, {
  required T param,
  Foo? otherParam,
}) {
  return <T>[];
}

@riverpod
class GenericClass<T extends num> extends _$GenericClass<T> {
  @override
  List<T> build() {
    return <T>[];
  }
}

@riverpod
Raw<Future<String>> rawFuture(RawFutureRef ref) async {
  return 'Hello world';
}

@riverpod
Raw<Stream<String>> rawStream(RawStreamRef ref) async* {
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
Raw<Future<String>> rawFamilyFuture(RawFamilyFutureRef ref, int id) async {
  return 'Hello world';
}

@riverpod
Raw<Stream<String>> rawFamilyStream(RawFamilyStreamRef ref, int id) async* {
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

const privateProvider = _privateProvider;

@riverpod
String _private(_PrivateRef ref) {
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

const privateClassProvider = _privateClassProvider;

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
String supports$InFnName<And$InT>(Supports$InFnNameRef<And$InT> ref) {
  return 'Hello world';
}

const default$value = '';

@riverpod
String supports$InFnNameFamily<And$InT>(
  Supports$InFnNameFamilyRef<And$InT> ref,
  And$InT positional$arg, {
  required And$InT named$arg,
  String defaultArg = default$value,
}) {
  return 'Hello world';
}

@riverpod
class Supports$InClassName<And$InT> extends _$Supports$InClassName<And$InT> {
  @override
  String build() {
    return 'Hello world';
  }
}

@riverpod
class Supports$InClassFamilyName<And$InT>
    extends _$Supports$InClassFamilyName<And$InT> {
  @override
  String build(
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg = default$value,
  }) {
    return 'Hello world';
  }
}

@riverpod
String generated(GeneratedRef ref) {
  return 'Just a simple normal generated provider';
}

r.Provider<String> someProvider() => r.Provider((ref) => 'hello');

// Regression test for https://github.com/rrousselGit/riverpod/issues/2299
final _someProvider = someProvider();

// Regression test for https://github.com/rrousselGit/riverpod/issues/2294
// ignore: unused_element
final _other = _someProvider;

// Regression test for now casting `as Object?` when not needed
@riverpod
String unnecessaryCast(GeneratedRef ref, Object? arg) {
  return 'Just a simple normal generated provider';
}

@riverpod
class UnnecessaryCastClass extends _$UnnecessaryCastClass {
  @override
  String build(Object? arg) {
    return 'Just a simple normal generated provider';
  }
}
