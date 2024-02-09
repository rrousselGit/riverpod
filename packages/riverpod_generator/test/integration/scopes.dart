import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scopes.g.dart';

@riverpod
external int scoped();

// TODO changelog added support for abstract build method.
@riverpod
class ScopedClass extends _$ScopedClass {
  int build();
}
