import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scopes.g.dart';

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
