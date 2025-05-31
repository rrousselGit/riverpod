// ignore_for_file: avoid_unused_constructor_parameters

import 'package:riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/experimental/persist.dart';
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
    await persist2(storage: ref.watch(storageProvider.future));
    return state.value ?? '';
  }
}

abstract class _$CustomAnnotation extends _$CustomAnnotationBase {
  FutureOr<void> persist2({
    Object? key,
    required FutureOr<Storage<Object, String>> storage,
    String Function(String state)? encode,
    String Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return persist(
      storage,
      key: key ?? 'CustomAnnotation',
      encode: encode ?? (value) => value,
      decode: decode ?? (encoded) => encoded.toString(),
      options: options,
    );
  }
}

@riverpod
@JsonPersist()
class Json extends _$Json {
  @override
  Future<Map<String, List<int>>> build(String arg) async {
    persistJson(ref.watch(storageProvider.future));

    return {};
  }
}

@riverpod
@JsonPersist()
class Json2 extends _$Json2 {
  @override
  Future<Map<String, List<int>>> build() async {
    persistJson(ref.watch(storageProvider.future));

    return {};
  }
}

@riverpod
@JsonPersist()
class CustomJson extends _$CustomJson {
  @override
  Future<Map<String, Bar>> build() async {
    await persistJson(ref.watch(storageProvider.future));

    return state.value ?? {};
  }
}

@riverpod
@JsonPersist()
class CustomKey extends _$CustomKey {
  @override
  String get key => 'My key';

  @override
  Future<Map<String, Bar>> build() async {
    await persistJson(ref.watch(storageProvider.future));

    return state.value ?? {};
  }
}

@riverpod
@JsonPersist()
class CustomJsonWithArgs extends _$CustomJsonWithArgs {
  @override
  Future<Map<String, Bar>> build(int arg, String arg2, {int? arg3}) async {
    await persistJson(ref.watch(storageProvider.future));

    return state.value ?? {};
  }
}

class Bar {
  const Bar(this.value);
  Bar.fromJson(Map<String, dynamic> json) : value = json['value'] as int;

  final int value;
  Map<String, dynamic> toJson() => {'value': value};
}

@riverpod
@JsonPersist()
class PassEncodeDecodeByHand extends _$PassEncodeDecodeByHand {
  @override
  Future<Map<String, String>> build() async {
    await persistJson(
      ref.watch(storageProvider.future),
      decode: (encoded) => {'value': encoded},
      encode: (state) => state['value']!,
    );

    return state.value ?? {};
  }
}
