import 'package:riverpod/persist.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline.g.dart';

class MyAnnotation implements RiverpodPersist {
  const MyAnnotation();
}

@riverpod
@MyAnnotation()
class CustomAnnotation extends _$CustomAnnotation {
  @override
  String build() => 'CustomAnnotation';
}

abstract class _$CustomAnnotation extends _$CustomAnnotationBase
    with NotifierEncoder<String, String, Object?> {
  @override
  Object get persistKey => 'CustomAnnotation';

  @override
  String decode(Object? value) => value! as String;

  @override
  Object? encode() => state;
}

@riverpod
@JsonPersist()
class Json extends _$Json {
  @override
  PersistOptions get persistOptions => const PersistOptions(
        cacheTime: PersistCacheTime.unsafe_forever,
      );

  @override
  Future<Map<String, List<int>>> build(String arg) async => {};
}
