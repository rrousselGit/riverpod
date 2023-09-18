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
String family(FamilyRef ref, int id) => 'family $id';

@riverpod
@doNotStore
String notCopiedFunctional(NotCopiedFunctionalRef ref) => 'notCopiedFunctional';

@riverpod
@doNotStore
class NotCopiedClassBased extends _$ClassBased {
  @override
  String build() => 'NotCopiedClassBased';
}

@riverpod
@doNotStore
String notCopiedFamily(NotCopiedFamilyRef ref, int id) => 'notCopiedFamily $id';
