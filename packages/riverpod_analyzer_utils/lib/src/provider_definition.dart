import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../riverpod_analyzer_utils.dart';
import 'ast_resolver.dart';
import 'recursive_import_locator.dart';

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
class LegacyProviderDependency with _$LegacyProviderDependency {
  /// A known provider definition, such as `dependencies: [provider, family]`
  @internal
  factory LegacyProviderDependency.provider(AnyProviderDefinition definition) =
      ProviderLegacyProviderDependency;

  /// A dependency that cannot be resolved statically, such as `[getProvider(), family(param)]`
  @internal
  factory LegacyProviderDependency.unknown(CollectionElement expression) =
      UnknownLegacyProviderDependency;

  /// A known provider definition, but the definition failed to parse
  @internal
  factory LegacyProviderDependency.errored(
    Object error,
    StackTrace stackTrace,
  ) = ErroredLegacyProviderDependency;
}

/// A list of dependencies for legacy providers
@freezed
class LegacyProviderDependencyList with _$LegacyProviderDependencyList {
  /// A list of dependencies defined using a list litteral: `dependencies: [...]`
  @internal
  factory LegacyProviderDependencyList.listLitteral(
    List<LegacyProviderDependency> list,
  ) = ListLitteralLegacyProviderDependencyList;

  /// A dependency list that cannot be resolved statically, such as `dependencies: fn()`
  @internal
  factory LegacyProviderDependencyList.unknown(Expression expression) =
      UnknownLegacyProviderDependencyList;
}

/// A dart representation for manually defined providers
@freezed
class LegacyProviderDefinition with _$LegacyProviderDefinition {
  factory LegacyProviderDefinition._({
    required String name,
    required bool isAutoDispose,
    required DartType? familyArgumentType,
    required LegacyProviderType providerType,
    required LegacyProviderDependencyList? dependencies,
  }) = _LegacyProviderDefinition;

  static final _definitionCache = Expando<Future<LegacyProviderDefinition>>();

  /// Parses code-generator definitions, rejecting manual provider definitions.
  ///
  /// May throw a [LegacyProviderDefinitionFormatException].
  static Future<LegacyProviderDefinition> parse(
    Element element, {
    required AstResolver resolver,
  }) {
    final cache = _definitionCache[element];
    if (cache != null) return cache;

    return _definitionCache[element] = Future(() {
      if (element is VariableElement) {
        // final provider = Provider(...);
        return _parseVariable(element, resolver: resolver);
      }

      throw LegacyProviderDefinitionFormatException.notAProvider();
    });
  }

  static Future<LegacyProviderDefinition> _parseVariable(
    VariableElement element, {
    required AstResolver resolver,
  }) async {
    final isFamily = familyType.isAssignableFromType(element.type);
    final isProvider = providerBaseType.isAssignableFromType(element.type);

    if (!isFamily && !isProvider) {
      throw LegacyProviderDefinitionFormatException.notAProvider();
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

    ArgumentList? arguments;
    if (initializer is InstanceCreationExpression) {
      // Provider((ref) => ...)
      arguments = initializer.argumentList;
    } else if (initializer is FunctionExpressionInvocation) {
      // Provider.modifier()
      arguments = initializer.argumentList;
    } else {
      throw UnsupportedError('Unknown type ${initializer.runtimeType}');
    }

    final dependenciesElement = arguments.arguments
        .whereType<NamedExpression>()
        .firstWhereOrNull((e) => e.name.label.name == 'dependencies');

    return LegacyProviderDefinition._(
      name: element.name,
      isAutoDispose: isAutoDispose,
      familyArgumentType: familyArgumentType,
      providerType: LegacyProviderType._parse(providerType),
      dependencies: dependenciesElement == null
          ? null
          : await _parseDependencies(
              dependenciesElement.expression,
              resolver: resolver,
            ),
    );
  }

  static Future<LegacyProviderDependencyList?> _parseDependencies(
    Expression expression, {
    required AstResolver resolver,
  }) async {
    if (expression is! ListLiteral) {
      // Unknown expressions such as `dependencies: function()`
      return LegacyProviderDependencyList.unknown(expression);
    }

    return LegacyProviderDependencyList.listLitteral(
      await Future.wait(
        expression.elements.map((e) => _parseDependency(e, resolver: resolver)),
      ),
    );
  }

  static Future<LegacyProviderDependency> _parseDependency(
    CollectionElement dependencyElement, {
    required AstResolver resolver,
  }) async {
    if (dependencyElement is! SimpleIdentifier) {
      // Unknown expressions, such as `dependencies: [fn()]
      return LegacyProviderDependency.unknown(dependencyElement);
    }

    try {
      // print(dependencyElement.staticElement?.nonSynthetic);
      // print(dependencyElement.staticElement?.nonSynthetic.runtimeType);
      // print('---');
      final definition = await AnyProviderDefinition.parse(
        dependencyElement.staticElement!.nonSynthetic,
        resolver: resolver,
      );
      return LegacyProviderDependency.provider(definition);
    } catch (err, stack) {
      return LegacyProviderDependency.errored(err, stack);
    }
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

/// Represents the possible values of `@Riverpod(dependencies: [...])`
@freezed
class GeneratorProviderDependency with _$GeneratorProviderDependency {
  /// A provider variable was passed in:
  ///
  /// ```dart
  /// @Riverpod(dependencies: [function, Notifier])
  /// ```
  @internal
  factory GeneratorProviderDependency.provider(
    GeneratorProviderDefinition definition,
  ) = ProviderGeneratorProviderDependency;

  GeneratorProviderDependency._();

  /// A [Symbol] was passed as dependency
  ///
  /// ```dart
  /// @Riverpod(dependencies: [#provider])
  /// ```
  @internal
  factory GeneratorProviderDependency.symbol(
    LegacyProviderDefinition definition,
  ) = SymbolGeneratorProviderDependency;
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

  /// Creates a Future/FutureOr
  bool get createsFuture => map((_) => false, future: (_) => true);
}

/// A dart representation for providers that needs code-generation
@freezed
class GeneratorProviderDefinition with _$GeneratorProviderDefinition {
  GeneratorProviderDefinition._();

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
    required List<GeneratorProviderDependency>? dependencies,
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
    required List<GeneratorProviderDependency>? dependencies,
  }) = NotifierGeneratorProviderDefinition;

  static final _definitionCache =
      Expando<Future<GeneratorProviderDefinition>>();

  /// Parses code-generator definitions, rejecting manual provider definitions.
  ///
  /// May throw a [GeneratorProviderDefinitionFormatException].
  static Future<GeneratorProviderDefinition> parse(
    Element element, {
    required AstResolver resolver,
  }) {
    final cache = _definitionCache[element];
    if (cache != null) return cache;

    return _definitionCache[element] = Future(() async {
      final annotations = riverpodType.annotationsOf(element);
      if (annotations.isEmpty) {
        throw GeneratorProviderDefinitionFormatException.notAProvider();
      }
      if (annotations.length > 1) {
        throw GeneratorProviderDefinitionFormatException.tooManyAnnotations();
      }

      final annotation = annotations.single;
      final keepAlive =
          annotation.getField('keepAlive')?.toBoolValue() ?? false;

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
          dependencies: await _parseDependencies(
            element.library,
            annotation,
            resolver: resolver,
          ),
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
          dependencies: await _parseDependencies(
            element.library,
            annotation,
            resolver: resolver,
          ),
        );
      }
      throw GeneratorProviderDefinitionFormatException
          .neitherClassNorFunction();
    });
  }

  /// Decode `dependencies: <Symbol | Function | Class>[...]`
  static Future<List<GeneratorProviderDependency>?> _parseDependencies(
    LibraryElement library,
    DartObject annotation, {
    required AstResolver resolver,
  }) async {
    final dependencies = annotation.getField('dependencies')?.toListValue();
    if (dependencies == null) return null;

    return Stream.fromIterable(dependencies).asyncMap((dependency) async {
      final type = dependency.type;
      if (type == null) {
        throw GeneratorProviderDefinitionFormatException
            .failedToParseDependency();
      }

      if (type.isDartCoreSymbol) {
        return _parseSymbolDependency(library, dependency, resolver: resolver);
      }

      return _parseProviderDependency(
        dependency,
        resolver: resolver,
      );
    }).toList();
  }

  static Future<ProviderGeneratorProviderDependency> _parseProviderDependency(
    DartObject dependency, {
    required AstResolver resolver,
  }) async {
    final dependencyElement =
        dependency.toFunctionValue() ?? dependency.toTypeValue()?.element2;

    if (dependencyElement == null) {
      throw GeneratorProviderDefinitionFormatException.notAProviderDependency();
    }

    try {
      // TODO throw on circular dependency
      final dependencyDefinition = await GeneratorProviderDefinition.parse(
        dependencyElement,
        resolver: resolver,
      );

      return ProviderGeneratorProviderDependency(dependencyDefinition);
    } on GeneratorProviderDefinitionFormatException catch (err, stack) {
      throw GeneratorProviderDefinitionFormatException.failedToParseDependency(
        error: err,
        stackTrace: stack,
      );
    }
  }

  static Future<SymbolGeneratorProviderDependency> _parseSymbolDependency(
    LibraryElement library,
    DartObject dependency, {
    required AstResolver resolver,
  }) async {
    if (false) {
      // TODO throw on circular dependency
    }

    final dependencySymbolString = dependency.toSymbolValue()!;

    final symbolProviderElement =
        library.findAllAvailableTopLevelElements().firstWhereOrNull(
              (e) => !e.isSynthetic && e.name == dependencySymbolString,
            );

    if (symbolProviderElement == null) {
      throw GeneratorProviderDefinitionFormatException
          .symbolDependencyNotFoundInScope(
        dependencySymbolString,
        library,
      );
    }

    try {
      // TODO throw on circular dependency
      final dependencyDefinition = await LegacyProviderDefinition.parse(
        symbolProviderElement,
        resolver: resolver,
      );

      return SymbolGeneratorProviderDependency(dependencyDefinition);
    } on LegacyProviderDefinitionFormatException catch (err, stack) {
      throw GeneratorProviderDefinitionFormatException.failedToParseDependency(
        error: err,
        stackTrace: stack,
      );
    }
  }

  static GeneratorCreatedType _parseStateTypeFromReturnType(
    DartType returnType,
  ) {
    if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
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
        throw GeneratorProviderDefinitionFormatException.noBuildMethod();
      },
    );
  }

  /// Is this provider defintion pointing to a notifier definition
  bool get isNotifier => map(functional: (_) => false, notifier: (_) => true);

  /// Is this provider defintion pointing to a plain function
  bool get isFunctional => map(functional: (_) => true, notifier: (_) => false);
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
      throw AnyProviderDefinitionFormatException.notAProvider();
    } on LegacyProviderDefinitionFormatException catch (err, stack) {
      Error.throwWithStackTrace(
        AnyProviderDefinitionFormatException.legacyException(err),
        stack,
      );
    }
  }

  /// Either a [LegacyProviderDefinition] or a [GeneratorProviderDefinition]
  Object get value {
    return map(legacy: (e) => e.value, generator: (e) => e.value);
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
  factory AnyProviderDefinitionFormatException.notAProvider() =
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
  factory GeneratorProviderDefinitionFormatException.notAProvider() =
      NotAProviderGeneratorProviderDefinitionFormatException;

  /// The element is correctly annotated by @riverpod, but is neither a class
  /// nor a function.
  factory GeneratorProviderDefinitionFormatException.neitherClassNorFunction() =
      NeitherClassNorFunctionGeneratorProviderDefinitionFormatException;

  /// The element was annotated with @riverpod more than once
  factory GeneratorProviderDefinitionFormatException.tooManyAnnotations() =
      TooManyAnnotationGeneratorProviderDefinitionFormatException;

  /// The element was annotated with @riverpod more than once
  factory GeneratorProviderDefinitionFormatException.noBuildMethod() =
      NoBuildMethodGeneratorProviderDefinitionFormatException;

  /// The element was annotated with @riverpod more than once
  @Assert(
    '(error == null && stackTrace == null) || (error != null && stackTrace != null)',
    'If error is specified, stackTrace must be specified too',
  )
  factory GeneratorProviderDefinitionFormatException.failedToParseDependency({
    Object? error,
    StackTrace? stackTrace,
  }) = FailedToParseDependencyGeneratorProviderDefinitionFormatException;

  /// `@Riverpod(dependencies: [...])` only accepts Symbols, Functions and Classes
  factory GeneratorProviderDefinitionFormatException.notAProviderDependency() =
      NotAProviderDependencyGeneratorProviderDefinitionFormatException;

  /// A [Symbol] dependency was specified, but the provider does not seem to exist
  /// or is not imported.
  factory GeneratorProviderDefinitionFormatException.symbolDependencyNotFoundInScope(
    String dependency,
    LibraryElement scope,
  ) = SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException;
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
  factory LegacyProviderDefinitionFormatException.notAProvider() =
      NotAProviderLegacyProviderDefinitionFormatException;

  LegacyProviderDefinitionFormatException._();
}
