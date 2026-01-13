import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

@riverpod
List<ItemT> generic<ItemT extends num>(Ref ref) {
  return <Object?>['Hello world', 42, 3.14].whereType<ItemT>().toList();
}

@riverpod
List<ItemT> complexGeneric<ItemT extends num, OtherT extends String?>(
  Ref ref, {
  required ItemT param,
  OtherT? otherParam,
}) {
  return <ItemT>[];
}

@riverpod
class GenericClass<ValueT extends num> extends _$GenericClass<ValueT>
    with MyMixin<List<ValueT>, List<ValueT>> {
  @override
  List<ValueT> build(ValueT param) {
    return <ValueT>[param];
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

final privateProvider = _privateProvider;

@riverpod
String _private(Ref ref) {
  return 'Hello world';
}

mixin MyMixin<StateT, ValueT> on AnyNotifier<StateT, ValueT> {}

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

final privateClassProvider = _privateClassProvider;

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
class LocalStaticDefault extends _$LocalStaticDefault {
  static const value = 'world';

  @override
  String build({String arg = value}) {
    return 'Hello $value';
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
class ManyProviderData<FirstT, SecondT> {}

@riverpod
Stream<List<ItemT>> manyDataStream<ItemT extends Object, OtherT extends Object>(
  Ref ref,
  ManyProviderData<ItemT, OtherT> pData,
) async* {}

// Regression for https://github.com/rrousselGit/riverpod/issues/4113
@riverpod
void issue4113(Ref ref) {}
@riverpod
void _issue4113(Ref ref) {}

final prov = issue4113Provider;
final prov2 = _issue4113Provider;

@Riverpod(name: 'manualRename')
String fn(Ref ref) => '';

final fnProv = manualRename;

@Riverpod(name: 'manualRename2')
String fn2(Ref ref, int a) => '';

final fn2Prov = manualRename2;

@riverpod
void voidFunctional(Ref ref) {}

@riverpod
void voidFunctionalWithArgs(Ref ref, int a) {}

@riverpod
class VoidClass extends _$VoidClass {
  @override
  void build() {}
}

@riverpod
class VoidClassWithArgs extends _$VoidClassWithArgs {
  @override
  void build(int a) {}
}
