import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../riverpod_analyzer_utils.dart';
import 'ast_resolver.dart';

part 'provider_definition.freezed.dart';

/// The class name for explicitly typed provider.
///
/// Such as `FutureProvider` for `final provider = FutureProvider(...)`.
/// This is only about the type, and does not include autoDispose/family/...
enum LegacyProviderType {
  /// Type for `ChangeNotifierProvider`
  changeNotifierProvider,

  /// Type for `FutureProvider`
  futureProvider,

  /// Type for `StreamProvider`
  streamProvider,

  /// Type for `StateNotifierProvider`
  stateNotifierProvider,

  /// Type for `StateProvider`
  stateProvider,

  /// Type for `NotifierProvider`
  notifierProvider,

  /// Type for `AsyncNotifierProvider`
  asyncNotifierProvider,

  /// Type for `Provider`
  provider;

  static LegacyProviderType _parse(DartType providerType) {
    if (anyFutureProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.futureProvider;
    }
    if (anyStreamProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.streamProvider;
    }
    if (anyStateProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.stateProvider;
    }
    if (anyStateNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.stateNotifierProvider;
    }
    if (anyProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.provider;
    }
    if (anyNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.notifierProvider;
    }
    if (anyAsyncNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.asyncNotifierProvider;
    }
    if (anyChangeNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.changeNotifierProvider;
    }

    throw StateError('Unknown provider type $providerType');
  }
}

/// A Dart representation of a provider definition.
@freezed
class ProviderDefinition with _$ProviderDefinition {
  /// Manually defined providers
  @internal
  factory ProviderDefinition.legacy({
    required String name,
    required bool isAutoDispose,
    required DartType? familyArgumentType,
    required LegacyProviderType providerType,
    List<int>? list,
  }) = LegacyProviderDefinition;

  /// Providers defined using the code generator
  @internal
  factory ProviderDefinition.generator({
    required String name,
    required bool isAutoDispose,
  }) = GeneratorProviderDefinition;

  ProviderDefinition._();

  /// Decode static analysis into a more humanly readable representation of a provider.
  ///
  /// This function will throw if the input is not a valid provider definition.
  ///
  /// The supported inputs as:
  ///
  /// - Variables, such as `final provider = Provider(...)`
  /// - Classes and functions annoted by `@riverpod`
  static Future<ProviderDefinition> parse(
    Element element, {
    required AstResolver resolver,
  }) async {
    if (element is VariableElement) {
      return _parseVariable(element, resolver: resolver);
      // final provider = Provider(...);
    } else if (element is FunctionElement) {
      // @riverpod
      // Model provider(ProviderRef ref) {...}
    } else if (element is ClassElement) {
      // @riverpod
      // Model provider(ProviderRef ref) {...}
    }

    throw ProviderDefinitionFormatException.notAProvider(element);
  }

  static Future<ProviderDefinition> _parseVariable(
    VariableElement element, {
    required AstResolver resolver,
  }) async {
    final isFamily = familyType.isAssignableFromType(element.type);
    final isProvider = providerBaseType.isAssignableFromType(element.type);

    if (!isFamily && !isProvider) {
      throw ProviderDefinitionFormatException.notAProvider(element);
    }

    final astNode = await resolver(element, resolve: true)
        .then((value) => value! as VariableDeclaration);

    final providerType = isProvider
        ? element.type
        : _getFamilyProviderType(element.type.element2! as InterfaceElement);

    final familyArgumentType =
        isProvider ? null : (element.type as InterfaceType).typeArguments.last;

    final initializer = astNode.initializer;
    final isAutoDispose =
        !alwaysAliveProviderListenableType.isAssignableFromType(providerType);

    if (initializer is InstanceCreationExpression) {
      // Provider((ref) => ...)
    } else if (initializer is FunctionExpressionInvocation) {
      // Provider.modifier()
    } else {
      throw UnsupportedError('Unknown type ${initializer.runtimeType}');
    }

    return ProviderDefinition.legacy(
      name: element.name,
      isAutoDispose: isAutoDispose,
      familyArgumentType: familyArgumentType,
      providerType: LegacyProviderType._parse(providerType),
    );
  }

  static DartType _getFamilyProviderType(InterfaceElement element) {
    final callMethod = element.allSupertypes
        .expand((e) => e.methods)
        .firstWhere(
          (element) => element.name == 'call',
          orElse: () =>
              throw StateError('Failed to find the "call" method in $element'),
        );

    return callMethod.returnType;
  }
}

/// Adds extensions to [LegacyProviderDefinition]
extension LegacyProviderDefinitionX on LegacyProviderDefinition {
  /// Whether the provider uses the family modifier
  bool get isFamily => familyArgumentType != null;
}

/// {@template ProviderDefinitionFormatException}
/// An exception thrown by [ProviderDefinition.parse] if it failed to parse the input.
///
/// The exception contains the failure reason.
/// {@endtemplate}
@freezed
class ProviderDefinitionFormatException
    with _$ProviderDefinitionFormatException
    implements Exception {
  /// {@macro ProviderDefinitionFormatException}
  factory ProviderDefinitionFormatException.notAProvider(Element element) =
      NotAProviderProviderDefinitionFormatException;

  ProviderDefinitionFormatException._();
}
