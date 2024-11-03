import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

@riverpod
List<T> generic<T extends num>(Ref ref) {
  return <Object?>[
    'Hello world',
    42,
    3.14,
  ].whereType<T>().toList();
}

@riverpod
List<T> complexGeneric<T extends num, Foo extends String?>(
  Ref ref, {
  required T param,
  Foo? otherParam,
}) {
  return <T>[];
}

@riverpod
class GenericClass<T extends num> extends _$GenericClass<T>
    with MyMixin<List<T>, List<T>> {
  @override
  List<T> build() {
    return <T>[];
  }
}

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

const privateProvider = _privateProvider;

@riverpod
String _private(Ref ref) {
  return 'Hello world';
}

mixin MyMixin<A, B> on NotifierBase<A, B> {}

/// This is some documentation
@riverpod
class PublicClass extends _$PublicClass with MyMixin<String, String> {
  PublicClass([this.param]);

  final Object? param;

  @override
  String build() {
    return 'Hello world';
  }
}

const privateClassProvider = _privateClassProvider;

@riverpod
class _PrivateClass extends _$PrivateClass with MyMixin<String, String> {
  @override
  String build() {
    return 'Hello world';
  }
}

/// This is some documentation
@riverpod
class FamilyClass extends _$FamilyClass with MyMixin<String, String> {
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
String supports$InFnName<And$InT>(Ref ref) {
  return 'Hello world';
}

const default$value = '';

@riverpod
String supports$InFnNameFamily<And$InT>(
  Ref ref,
  And$InT positional$arg, {
  required And$InT named$arg,
  String defaultArg = default$value,
}) {
  return 'Hello world';
}

@riverpod
class Supports$InClassName<And$InT> extends _$Supports$InClassName<And$InT>
    with MyMixin<String, String> {
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
String generated(Ref ref) {
  return 'Just a simple normal generated provider';
}

Provider<String> someProvider() => Provider((ref) => 'hello');

// Regression test for https://github.com/rrousselGit/riverpod/issues/2299
final _someProvider = someProvider();

// Regression test for https://github.com/rrousselGit/riverpod/issues/2294
// ignore: unused_element
final _other = _someProvider;

// Regression test for now casting `as Object?` when not needed
@riverpod
String unnecessaryCast(Ref ref, Object? arg) {
  return 'Just a simple normal generated provider';
}

@riverpod
class UnnecessaryCastClass extends _$UnnecessaryCastClass {
  @override
  String build(Object? arg) {
    return 'Just a simple normal generated provider';
  }
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/3249
class ManyProviderData<T, S> {}

@riverpod
Stream<List<T>> manyDataStream<T extends Object, S extends Object>(
  Ref ref,
  ManyProviderData<T, S> pData,
) async* {}
