import 'package:riverpod_annotation/experimental/mutation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mutation.g.dart';

class Todo {}

@riverpod
class SyncTodoList extends _$SyncTodoList {
  @override
  List<Todo> build() => [];

  @mutation
  Todo addSync(Todo todo) {
    state.add(todo);
    return todo;
  }

  @mutation
  Future<Todo> addAsync(Todo todo) async {
    state.add(todo);
    return todo;
  }
}

@riverpod
class AsyncTodoList extends _$AsyncTodoList {
  @override
  Future<List<Todo>> build() async => [];

  @mutation
  Todo addSync(Todo todo) {
    state = AsyncData([...state.requireValue, todo]);
    return todo;
  }

  @mutation
  Future<Todo> addAsync(Todo todo) async {
    state = AsyncData([...state.requireValue, todo]);
    return todo;
  }
}

@riverpod
class Simple extends _$Simple {
  @override
  int build() => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state += inc;

  @mutation
  FutureOr<int> incrementOr() => state++;

  @mutation
  Future<int> delegated(Future<int> Function() fn) async => state = await fn();
}

@riverpod
class SimpleFamily extends _$SimpleFamily {
  @override
  int build(String arg) => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state += inc;

  @mutation
  FutureOr<int> incrementOr() => state++;
}

@riverpod
class SimpleAsync extends _$SimpleAsync {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment([int inc = 1]) async {
    state = AsyncData((await future) + inc);

    return state.requireValue;
  }

  @mutation
  Future<int> delegated(Future<int> Function() fn) async {
    await future;
    state = AsyncData(await fn());

    return state.requireValue;
  }
}

@riverpod
class SimpleAsync2 extends _$SimpleAsync2 {
  @override
  Stream<int> build(String arg) => Stream.value(0);

  @mutation
  Future<int> increment() async {
    state = AsyncData((await future) + 1);
    return state.requireValue;
  }
}

@riverpod
class Generic<T extends num> extends _$Generic<T> {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment() async {
    state = AsyncData((await future) + 1);
    return state.requireValue;
  }
}

@riverpod
class GenericMut extends _$GenericMut {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment<T extends num>(T value) async {
    state = AsyncData((await future) + value.ceil());
    return state.requireValue;
  }
}

@riverpod
class FailingCtor extends _$FailingCtor {
  FailingCtor() {
    throw StateError('err');
  }

  @override
  int build() => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state += inc;
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
