part of '../framework.dart';

@internal
abstract class DebugDependentSource {}

@internal
sealed class DebugProviderDependentSource extends DebugDependentSource {
  DebugProviderDependentSource._({required this.provider});

  final Provider<Object?> provider;
}

@internal
final class DebugRefWatchDependentSource extends DebugProviderDependentSource {
  DebugRefWatchDependentSource({required super.provider}) : super._();
}

@internal
final class DebugRefListenDependentSource extends DebugProviderDependentSource {
  DebugRefListenDependentSource({required super.provider}) : super._();
}

@internal
final class DebugRefReadDependentSource extends DebugProviderDependentSource {
  DebugRefReadDependentSource({required super.provider}) : super._();
}

@internal
final class DebugRefInvalidateDependentSource
    extends DebugProviderDependentSource {
  DebugRefInvalidateDependentSource({required super.provider}) : super._();
}

@internal
final class DebugRefRefreshDependentSource
    extends DebugProviderDependentSource {
  DebugRefRefreshDependentSource({required super.provider}) : super._();
}

@internal
final class DebugRefReloadDependentSource extends DebugProviderDependentSource {
  DebugRefReloadDependentSource({required super.provider}) : super._();
}

@internal
final class DebugRefExistsDependentSource extends DebugProviderDependentSource {
  DebugRefExistsDependentSource({required super.provider}) : super._();
}
