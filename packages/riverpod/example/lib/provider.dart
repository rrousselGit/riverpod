import 'package:riverpod/experiments/providers.dart';

import 'common.dart';

final prov = Provider2.async<int>((ref) {
  return ref.setData(42);
});
final syncProv = Provider2.sync((ref) => 42);

Future<void> provMain() async {
  final container = ProviderContainer();

  final int value = await container.read2(prov.future);
  AsyncValue<int> value2 = prov.watch(container);

  final int value3 = container.read2(syncProv);
  int value4 = syncProv.watch(container);
}

class CustomProv extends CustomProvider2<AsyncValue<int>> {
  late final $addTodo = mutation<Todo>();
  MutationCall<Todo> addTodo(String text) => mutate($addTodo, (ref) async {
        final state = await ref.future;
        ref.setData(42);
        return Todo('id');
      });

  @override
  late final create = async((ref) => ref.setData(42));
}

Future<void> customProv() async {
  final container = ProviderContainer();

  AsyncValue<int> value = container.read2(CustomProv());
  MutationState<Todo> addTodo = container.read2(CustomProv().$addTodo);
  Todo newTodo = await container.invoke(CustomProv().addTodo('text'));
}

class Test extends CustomProvider2<int> {
  Test(this.id);

  final String id;

  @override
  Record get args => (id,);

  late final $addTodo = mutation<Todo>(#addTodo);
  MutationCall<Todo> addTodo(String text) => mutate($addTodo, (ref) async {
        print(id);
        int state = ref.state!.value!;
        ref.setData(42 + state);
        return Todo('id');
      });

  @override
  late final create = sync((ref) {
    print(id);
    return 42;
  });
}

Future<void> test() async {
  final container = ProviderContainer();

  int value = container.read2(Test('id'));
  MutationState<Todo> addTodo = container.read2(Test('id').$addTodo);
  Todo newTodo = await container.invoke(Test('id').addTodo('text'));
}
