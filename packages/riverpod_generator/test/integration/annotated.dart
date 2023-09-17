import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'annotated.g.dart';

@riverpod
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
String functional(FunctionalRef ref) => 'functional';

@riverpod
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
class ClassBased extends _$ClassBased {
  @override
  String build() => 'ClassBased';
}

@riverpod
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
String familyFunctional(FamilyFunctionalRef ref, int id) =>
    'familyFunctional $id';

@riverpod
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
class FamilyClassBased extends _$FamilyClassBased {
  @override
  String build(int id) => 'FamilyClassBased $id';
}

@riverpod
@doNotStore
String notCopied(NotCopiedRef ref) => 'not copied';

@riverpod
@doNotStore
String notCopiedFamily(NotCopiedFamilyRef ref, int id) => 'not copied $id';
