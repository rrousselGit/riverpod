import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documented.g.dart';

/// Hello world
// Foo
@riverpod
String functional(FunctionalRef ref) => 'functional';

/// Hello world
// Foo
@riverpod
class ClassBased extends _$ClassBased {
  @override
  String build() => 'ClassBased';
}

/// Hello world
// Foo
@riverpod
String family(
  FamilyRef ref,

  /// Hello Id
  int id,
) {
  return 'family $id';
}

/// Hello world
// Foo
@riverpod
class ClassFamilyBased extends _$ClassFamilyBased {
  @override
  String build(
    /// Hello world
    // Foo
    int id,
  ) =>
      'ClassBased';
}
