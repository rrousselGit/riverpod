import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documented.g.dart';

const annotation = Object();

/// Hello world
// Foo
@riverpod
@annotation
String functional(Ref ref) => 'functional';

/// Hello world
// Foo
@riverpod
@annotation
class ClassBased extends _$ClassBased {
  @override
  String build() => 'ClassBased';
}

/// Hello world
// Foo
@riverpod
@annotation
String family(
  Ref ref,

  /// Hello Id
  int id,
) {
  return 'family $id';
}

/// Hello world
// Foo
@riverpod
@annotation
class ClassFamilyBased extends _$ClassFamilyBased {
  @override
  String build(
    /// Hello world
    // Foo
    @annotation int id,
  ) =>
      'ClassBased';
}
