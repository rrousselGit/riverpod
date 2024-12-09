import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'annotated.g.dart';

@riverpod
@Deprecated('Deprecation message')
@visibleForTesting
@protected
String functional(Ref ref, @Deprecated('field') int id) => 'functional';

@riverpod
@Deprecated('Deprecation message')
@visibleForTesting
@protected
class ClassBased extends _$ClassBased {
  @override
  String build(@Deprecated('field') int id) => 'ClassBased';
}

@riverpod
@Deprecated('Deprecation message')
@visibleForTesting
@protected
String family(Ref ref, int id) => 'family $id';

@riverpod
@doNotStore
String notCopiedFunctional(Ref ref) => 'notCopiedFunctional';

@riverpod
@doNotStore
class NotCopiedClassBased extends _$NotCopiedClassBased {
  @override
  String build() => 'NotCopiedClassBased';
}

@riverpod
@doNotStore
String notCopiedFamily(Ref ref, int id) => 'notCopiedFamily $id';
