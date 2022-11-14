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

/// A dart representation for manually defined providers
@freezed
class LegacyProviderDefinition with _$LegacyProviderDefinition {
  factory LegacyProviderDefinition._({
    required String name,
    required bool isAutoDispose,
    required DartType? familyArgumentType,
    required LegacyProviderType providerType,
  }) = _LegacyProviderDefinition;

  /// Parses code-generator definitions, rejecting manual provider definitions.
  ///
  /// May throw a [LegacyProviderDefinitionFormatException].
  static Future<LegacyProviderDefinition> parse(
    Element element, {
    required AstResolver resolver,
  }) {
    if (element is VariableElement) {
      // final provider = Provider(...);
      return _parseVariable(element, resolver: resolver);
    }
    throw LegacyProviderDefinitionFormatException.notAProvider(element);
  }

  static Future<LegacyProviderDefinition> _parseVariable(
    VariableElement element, {
    required AstResolver resolver,
  }) async {
    final isFamily = familyType.isAssignableFromType(element.type);
    final isProvider = providerBaseType.isAssignableFromType(element.type);

    if (!isFamily && !isProvider) {
      throw LegacyProviderDefinitionFormatException.notAProvider(element);
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

    return LegacyProviderDefinition._(
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

/// A dart representation for providers that needs code-generation
@freezed
class GeneratorCreatedType with _$GeneratorCreatedType {
  /// A value that is not any other valid known type.
  @Assert('createdType == stateType')
  @internal
  factory GeneratorCreatedType({
    required DartType createdType,
    required DartType stateType,
  }) = PlainGeneratorCreatedType;

  GeneratorCreatedType._();

  /// A user-defined FutureOr<T>
  @internal
  factory GeneratorCreatedType.futureOr({
    required InterfaceType createdType,
    required DartType stateType,
  }) = FutureGeneratorCreatedType;

  /// A user-defined Future<T>
  @internal
  factory GeneratorCreatedType.future({
    required InterfaceType createdType,
    required DartType stateType,
  }) = FutureOrGeneratorCreatedType;

  /// [createdType] is the raw [DartType] corresponding to the return value of the "create" function
  DartType get createdType {
    return map(
      (value) => value.createdType,
      futureOr: (value) => value.createdType,
      future: (value) => value.createdType,
    );
  }

  /// [stateType] is the user-defined provider type trimmed from the encapsulating type.
  ///
  /// Such that:
  ///
  /// ```dart
  /// int provider(ref) {...}
  /// Future<int> provider(ref) {...}
  /// FutureOr<int> provider(ref) {...}
  /// ```
  ///
  /// all have `int` as [stateType].
  @override
  DartType get stateType;
}

/// A dart representation for providers that needs code-generation
@freezed
class GeneratorProviderDefinition with _$GeneratorProviderDefinition {
  /// A function-based generated provider definition, such as:
  ///
  /// ```dart
  /// @riverpod
  /// int counter(CounterRef ref) => 0;
  @internal
  factory GeneratorProviderDefinition.functional({
    required String name,

    /// Information about the type of the value exposed
    required GeneratorCreatedType type,
    required bool isAutoDispose,
    required List<ParameterElement> parameters,
    required String? docs,
  }) = FunctionalGeneratorProviderDefinition;

  /// A class-based generated provider definition, such as:
  ///
  /// ```dart
  /// @riverpod
  /// class Counter extends _$Counter {
  ///   @override
  ///   int count() => 0;
  /// }
  /// ```
  @internal
  factory GeneratorProviderDefinition.notifier({
    required String name,

    /// Information about the type of the value exposed
    required GeneratorCreatedType type,
    required bool isAutoDispose,
    required List<ParameterElement> parameters,
    required String? docs,
  }) = NotifierGeneratorProviderDefinition;

  /// Parses code-generator definitions, rejecting manual provider definitions.
  ///
  /// May throw a [GeneratorProviderDefinitionFormatException].
  static Future<GeneratorProviderDefinition> parse(
    Element element, {
    required AstResolver resolver,
  }) async {
    final annotations = riverpodType.annotationsOf(element);
    if (annotations.isEmpty) {
      throw GeneratorProviderDefinitionFormatException.notAProvider(element);
    }
    if (annotations.length > 1) {
      throw GeneratorProviderDefinitionFormatException.tooManyAnnotations(
        element,
      );
    }

    final annotation = annotations.single;
    final keepAlive = annotation.getField('keepAlive')?.toBoolValue() ?? false;

    if (element is FunctionElement) {
      // TODO throw if "ref" is not a positional parameter or has a type mismatch

      // @riverpod
      // Model provider(ProviderRef ref) {...}
      return FunctionalGeneratorProviderDefinition(
        name: element.name,
        isAutoDispose: !keepAlive,
        type: _parseStateTypeFromReturnType(element.returnType),
        parameters: element.parameters
            // Removing the "ref" parameter
            .skip(1)
            .toList(),
        docs: element.documentationComment,
      );
    } else if (element is ClassElement) {
      final buildMethod = _findNotifierBuildMethod(element);

      // @riverpod
      // class Counter extends _$Counter {...}
      return NotifierGeneratorProviderDefinition(
        name: element.name,
        isAutoDispose: !keepAlive,
        type: _parseStateTypeFromReturnType(buildMethod.returnType),
        parameters: buildMethod.parameters,
        docs: element.documentationComment,
      );
    }
    throw GeneratorProviderDefinitionFormatException.neitherClassNorFunction(
      element,
    );
  }

  static GeneratorCreatedType _parseStateTypeFromReturnType(
    DartType returnType,
  ) {
    if (returnType.isDartAsyncFutureOr) {
      final interfaceType = returnType as InterfaceType;
      return GeneratorCreatedType.futureOr(
        stateType: interfaceType.typeArguments.single,
        createdType: interfaceType,
      );
    } else if (returnType.isDartAsyncFuture) {
      final interfaceType = returnType as InterfaceType;
      return GeneratorCreatedType.future(
        stateType: interfaceType.typeArguments.single,
        createdType: interfaceType,
      );
    } else {
      return GeneratorCreatedType(
        stateType: returnType,
        createdType: returnType,
      );
    }
  }

  static MethodElement _findNotifierBuildMethod(ClassElement element) {
    return element.methods.firstWhere(
      (element) => element.name == 'build',
      orElse: () {
        throw GeneratorProviderDefinitionFormatException.noBuildMethod(element);
      },
    );
  }
}

/// A dart representation of either code-gen-based providers or manually defined providers.
@freezed
class AnyProviderDefinition with _$AnyProviderDefinition {
  /// Manually defined providers
  @internal
  factory AnyProviderDefinition.legacy(LegacyProviderDefinition value) =
      LegacyAnyProviderDefinition;

  /// Providers defined using the code generator
  @internal
  factory AnyProviderDefinition.generator(GeneratorProviderDefinition value) =
      GeneratorAnyProviderDefinition;

  AnyProviderDefinition._();

  /// Decode static analysis into a more humanly readable representation of a provider.
  ///
  /// This function will throw if the input is not a valid provider definition.
  ///
  /// The supported inputs as:
  ///
  /// - Variables, such as `final provider = Provider(...)`
  /// - Classes and functions annoted by `@riverpod`
  static Future<AnyProviderDefinition> parse(
    Element element, {
    required AstResolver resolver,
  }) async {
    try {
      return GeneratorAnyProviderDefinition(
        await GeneratorProviderDefinition.parse(element, resolver: resolver),
      );
    } on NotAProviderGeneratorProviderDefinitionFormatException {
      // The element is not a code-generation-based provider. Let's try another
      // decoding mechanism.
      // For readability, let's not nest try-catch blocks
    } on GeneratorProviderDefinitionFormatException catch (err, stack) {
      Error.throwWithStackTrace(
        AnyProviderDefinitionFormatException.generatorException(err),
        stack,
      );
    }

    try {
      return LegacyAnyProviderDefinition(
        await LegacyProviderDefinition.parse(
          element,
          resolver: resolver,
        ),
      );
    } on NotAProviderLegacyProviderDefinitionFormatException {
      // We reached the end of the possible decoding mechanism, so element is 100%
      // not a provider.
      throw AnyProviderDefinitionFormatException.notAProvider(element);
    } on LegacyProviderDefinitionFormatException catch (err, stack) {
      Error.throwWithStackTrace(
        AnyProviderDefinitionFormatException.legacyException(err),
        stack,
      );
    }
  }
}

/// Adds extensions to [LegacyProviderDefinition]
extension LegacyProviderDefinitionX on LegacyProviderDefinition {
  /// Whether the provider uses the family modifier
  bool get isFamily => familyArgumentType != null;
}

/// {@template ProviderDefinitionFormatException}
/// An exception thrown by [AnyProviderDefinition.parse] if it failed to parse the input.
///
/// The exception contains the failure reason.
/// {@endtemplate}
@freezed
class AnyProviderDefinitionFormatException
    with _$AnyProviderDefinitionFormatException
    implements Exception {
  /// The element does not represent a provider definition.
  factory AnyProviderDefinitionFormatException.generatorException(
    GeneratorProviderDefinitionFormatException exception,
  ) = GeneratorAnyProviderDefinitionFormatException;

  /// The element does not represent a provider definition.
  factory AnyProviderDefinitionFormatException.legacyException(
    LegacyProviderDefinitionFormatException exception,
  ) = LegacyAnyProviderDefinitionFormatException;

  /// The element does not represent a provider definition.
  factory AnyProviderDefinitionFormatException.notAProvider(Element element) =
      NotAProviderProviderDefinitionFormatException;

  AnyProviderDefinitionFormatException._();
}

/// {@template ProviderDefinitionFormatException}
/// An exception thrown by [AnyProviderDefinition.parse] if it failed to parse the input.
///
/// The exception contains the failure reason.
/// {@endtemplate}
@freezed
class GeneratorProviderDefinitionFormatException
    with _$GeneratorProviderDefinitionFormatException
    implements Exception {
  /// The element does not represent a provider definition.
  factory GeneratorProviderDefinitionFormatException.notAProvider(
    Element element,
  ) = NotAProviderGeneratorProviderDefinitionFormatException;

  /// The element is correctly annotated by @riverpod, but is neither a class
  /// nor a function.
  factory GeneratorProviderDefinitionFormatException.neitherClassNorFunction(
    Element element,
  ) = NeitherClassNorFunctionGeneratorProviderDefinitionFormatException;

  /// The element was annotated with @riverpod more than once
  factory GeneratorProviderDefinitionFormatException.tooManyAnnotations(
    Element element,
  ) = TooManyAnnotationGeneratorProviderDefinitionFormatException;

  /// The element was annotated with @riverpod more than once
  factory GeneratorProviderDefinitionFormatException.noBuildMethod(
    Element element,
  ) = NoBuildMethodGeneratorProviderDefinitionFormatException;
}

/// {@template ProviderDefinitionFormatException}
/// An exception thrown by [AnyProviderDefinition.parse] if it failed to parse the input.
///
/// The exception contains the failure reason.
/// {@endtemplate}
@freezed
class LegacyProviderDefinitionFormatException
    with _$LegacyProviderDefinitionFormatException
    implements Exception {
  /// The element does not represent a provider definition.
  factory LegacyProviderDefinitionFormatException.notAProvider(
    Element element,
  ) = NotAProviderLegacyProviderDefinitionFormatException;

  LegacyProviderDefinitionFormatException._();
}
