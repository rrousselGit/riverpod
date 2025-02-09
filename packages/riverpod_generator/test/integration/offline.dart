import 'package:riverpod/persist.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline.g.dart';

class MyAnnotation implements RiverpodPersist {
  const MyAnnotation();
}

@riverpod
FutureOr<Storage<String, String>> storage(Ref ref) {
  return Storage<String, String>.inMemory();
}

@riverpod
@MyAnnotation()
class CustomAnnotation extends _$CustomAnnotation {
  @override
  Future<String> build() async {
    await persist(storage: ref.watch(storageProvider.future));
    return state.value ?? '';
  }
}

abstract class _$CustomAnnotation extends _$CustomAnnotationBase
    with Persistable<String, Object, String> {
  @override
  FutureOr<void> persist({
    Object? key,
    required FutureOr<Storage<Object, String>> storage,
    String Function(String state)? encode,
    String Function(String encoded)? decode,
    PersistOptions options = const PersistOptions(),
  }) {
    return super.persist(
      key: key ?? 'CustomAnnotation',
      storage: storage,
      encode: encode ?? (value) => value,
      decode: decode ?? (encoded) => encoded,
      options: options,
    );
  }
}

@riverpod
@JsonPersist()
class Json extends _$Json {
  @override
  Future<Map<String, List<int>>> build(String arg) async {
    persist(storage: ref.watch(storageProvider.future));

    return {};
  }
}
