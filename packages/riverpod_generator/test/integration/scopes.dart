import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scopes.g.dart';

// TODO changelog added support for abstract build method.
@riverpod
class ScopedClass extends _$ScopedClass {
  @override
  int build();
}

@riverpod
class ScopedClassFamily extends _$ScopedClassFamily {
  @override
  int build(int a);
}
