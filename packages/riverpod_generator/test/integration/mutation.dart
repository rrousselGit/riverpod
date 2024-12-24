import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mutation.g.dart';

@riverpod
class Simple extends _$Simple {
  @override
  int build() => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state + inc;

  @mutation
  FutureOr<int> incrementOr() => state + 1;

  @mutation
  Future<int> delegated(Future<int> Function() fn) => fn();
}

@riverpod
class SimpleFamily extends _$SimpleFamily {
  @override
  int build(String arg) => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state + inc;

  @mutation
  FutureOr<int> incrementOr() => state + 1;
}

@riverpod
class SimpleAsync extends _$SimpleAsync {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => (await future) + inc;

  @mutation
  Future<int> delegated(Future<int> Function() fn) async {
    await future;
    return fn();
  }
}

@riverpod
class SimpleAsync2 extends _$SimpleAsync2 {
  @override
  Stream<int> build(String arg) => Stream.value(0);

  @mutation
  Future<int> increment() async => (await future) + 1;
}

@riverpod
class Generic<T extends num> extends _$Generic<T> {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment() async => (await future) + 1;
}

@riverpod
class GenericMut extends _$GenericMut {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment<T extends num>(T value) async =>
      (await future) + value.ceil();
}

@riverpod
class FailingCtor extends _$FailingCtor {
  FailingCtor() {
    throw StateError('err');
  }

  @override
  int build() => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state + inc;
}

@riverpod
class Typed extends _$Typed {
  @override
  String build() => 'typed';

  @mutation
  Future<String> mutate(
    String one, {
    required String two,
    required String three,
  }) async =>
      '$one $two $three';
}
