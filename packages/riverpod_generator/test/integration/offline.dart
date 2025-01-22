import 'package:riverpod_annotation/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline.g.dart';

class MyAnnotation implements RiverpodPersist {
  const MyAnnotation();
}

@riverpod
@MyAnnotation()
class Offline extends _$Offline {
  @override
  String build() => 'Offline';
}
