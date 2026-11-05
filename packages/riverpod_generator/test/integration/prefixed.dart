// Every generated reference to the API of riverpod_annotation should use the
// prefix of its import.
import 'package:riverpod_annotation/experimental/json_persist.dart' as r;
import 'package:riverpod_annotation/experimental/persist.dart' as r;
import 'package:riverpod_annotation/riverpod_annotation.dart' as r;

part 'prefixed.g.dart';

@r.riverpod
int value(r.Ref ref) => 0;

@r.riverpod
Future<int> future(r.Ref ref) async => 0;

@r.riverpod
Stream<int> stream(r.Ref ref) => const Stream.empty();

@r.Riverpod(dependencies: [value])
int family(r.Ref ref, int arg) => ref.watch(valueProvider);

@r.riverpod
List<ItemT> genericFamily<ItemT>(r.Ref ref, ItemT item) => [item];

@r.riverpod
class ValueClass extends _$ValueClass {
  @override
  int build() => 0;
}

@r.riverpod
class FutureClass extends _$FutureClass {
  @override
  Future<int> build() async => 0;
}

@r.riverpod
class StreamClass extends _$StreamClass {
  @override
  Stream<int> build() => const Stream.empty();
}

@r.riverpod
class FamilyClass extends _$FamilyClass {
  @override
  int build(int arg) => arg;
}

@r.riverpod
class GenericClass<ItemT> extends _$GenericClass<ItemT> {
  @override
  List<ItemT> build(ItemT item) => [item];
}

@r.riverpod
class Scoped extends _$Scoped {
  @override
  int build();
}

@r.riverpod
r.FutureOr<r.Storage<String, String>> storage(r.Ref ref) {
  return r.Storage<String, String>.inMemory();
}

@r.riverpod
@r.JsonPersist()
class Json extends _$Json {
  @override
  Future<Map<String, int>> build() async {
    persist(ref.watch(storageProvider.future));
    return {};
  }
}
