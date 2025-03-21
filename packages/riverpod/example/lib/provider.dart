import 'dart:async';

import 'package:riverpod/experiments/mutations.dart';
import 'package:riverpod/experiments/providers.dart';

import 'common.dart';

final value = SyncProvider<int>((ref) {
  return 42;
});
final future = AsyncProvider<int>((ref) async {
  return 42;
});
final stream = AsyncProvider<int>((ref) async {
  ref.emit(Stream.value(42));
});

class ValueProvider with SyncProvider<int> {
  @override
  int build(ref) => 42;
}

class FutureProvider with AsyncProvider<int> {
  @override
  int build(ref) => 42;
}

class StreamProvider with AsyncProvider<int> {
  @override
  int build(ref) => ref.emit(Stream.value(42));
}

final prov = AsyncProvider<int>((ref) => 42);
final syncProv = SyncProvider((ref) => 42);

Future<void> provMain() async {
  final container = ProviderContainer();

  final value = await container.read(prov.future);
  final value2 = container.read(prov);

  final value3 = container.read(syncProv);
  final value4 = container.read(syncProv);
}

class CustomProv with AsyncProvider<int> {
  late final $addTodo = mutation<Todo>();
  Call<Future<Todo>> addTodo(String text) => mutate($addTodo, (ref) async {
    final state = await ref.future;
    ref.setData(42);
    return Todo('id');
  });

  @override
  FutureOr<int> build(ref) => 42;
}

final customProv = CustomProv();

Future<void> customProvMain() async {
  final container = ProviderContainer();

  final value = container.read(customProv);
  final addTodo = container.read(customProv.$addTodo);
  final newTodo = await container.invoke(customProv.addTodo('text'));
  container.invoke(customProv.$addTodo.reset());
}

class Test with SyncProvider<int> {
  Test(this.id);

  final String id;

  @override
  Record get args => (id,);

  late final $addTodo = mutation<Todo>(#addTodo);
  Call<Future<Todo>> addTodo(String text) => mutate($addTodo, (ref) async {
    print(id);
    final state = ref.state!;
    ref.setData(42 + state);
    return Todo('id');
  });

  @override
  int build(ref) {
    print(id);
    return 42;
  }
}

Future<void> testMain() async {
  final container = ProviderContainer();

  final value = container.read(Test('id'));
  final addTodo = container.read(Test('id').$addTodo);
  final newTodo = await container.invoke(Test('id').addTodo('text'));
}

void main() {
  provMain();
  customProvMain();
  testMain();
}
