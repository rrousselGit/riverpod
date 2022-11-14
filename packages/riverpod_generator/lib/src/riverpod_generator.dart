import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

// ignore: implementation_imports
import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
// ignore: implementation_imports, safe as we are the one controlling this file
import 'package:riverpod_annotation/src/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';
import 'templates/family.dart';
import 'templates/hash.dart';
import 'templates/notifier.dart';
import 'templates/provider.dart';
import 'templates/ref.dart';

extension on String {
  String get camelCase {
    if (startsWith('_')) {
      final numUnderscores = RegExp('^_*').firstMatch(this)!.group(0)!.length;
      final underscore = '_' * numUnderscores;
      return underscore + substring(numUnderscores).camelCase;
    }
    return '${this[0].toLowerCase()}${substring(1)}';
  }
}

@immutable
// ignore: invalid_use_of_internal_member
class RiverpodGenerator
    extends ParserGenerator<GlobalData, GeneratorProviderDefinition, Riverpod> {
  RiverpodGenerator(this.configs);

  final Map<String, Object?> configs;

  @override
  GlobalData parseGlobalData(LibraryElement library) {
    return GlobalData();
  }

  @override
  Future<GeneratorProviderDefinition> parseElement(
    BuildStep buildStep,
    GlobalData globalData,
    Element element,
  ) async {
    try {
      // Necessary await for the try/catch to catch async errors
      return await GeneratorProviderDefinition.parse(
        element,
        resolver: buildStep.resolver.astNodeFor,
      );
    } on GeneratorProviderDefinitionFormatException catch (err, stack) {
      err.map(
        notAProvider: (e) {
          Error.throwWithStackTrace(
            InvalidGenerationSourceError(
              '@riverpod used on something that is not a provider',
              element: e.element,
            ),
            stack,
          );
        },
        neitherClassNorFunction: (e) {
          Error.throwWithStackTrace(
            InvalidGenerationSourceError(
              '@riverpod can only be applied on functions and classes. Failing element: ${element.name}',
              element: e.element,
            ),
            stack,
          );
        },
        tooManyAnnotations: (e) {
          Error.throwWithStackTrace(
            InvalidGenerationSourceError(
              '@riverpod can only be used once per element',
              element: e.element,
            ),
            stack,
          );
        },
        noBuildMethod: (e) {
          Error.throwWithStackTrace(
            InvalidGenerationSourceError(
              '@riverpod classes must define a build method',
              element: e.element,
            ),
            stack,
          );
        },
      );
    }

    // if (element is FunctionElement) {
    //   return _parseFunctionElement(buildStep, globalData, element);
    // } else if (element is ClassElement) {
    //   return _parseClassElement(buildStep, globalData, element);
    // } else {
    //   throw InvalidGenerationSourceError(
    //     '@riverpod can only be applied on functions and classes. Failing element: ${element.name}',
    //     element: element,
    //   );
    // }
  }

  bool _getKeepAlive(DartObject element) {
    return element.getField('keepAlive')?.toBoolValue() ?? false;
  }

  // FutureOr<Data> _parseFunctionElement(
  //   BuildStep buildStep,
  //   GlobalData globalData,
  //   FunctionElement element,
  // ) async {
  //   final riverpod = riverpodType.firstAnnotationOf(element)!;

  //   return Data.function(
  //     createElement: element,
  //     createAst: (await buildStep.resolver.astNodeFor(element, resolve: true))!,
  //     providerDoc: element.documentationComment == null
  //         ? '/// See also [${element.name}].'
  //         : '${element.documentationComment}\n///\n/// Copied from [${element.name}].',
  //     rawName: element.name,
  //     keepAlive: _getKeepAlive(riverpod),
  //     isScoped: element.isExternal,
  //     // functional providers have a "ref" has parameter, so families have at
  //     // least 2 parameters.
  //     isFamily: element.parameters.length > 1,
  //     isAsync: _isBuildAsync(element),
  //     functionName: element.name,
  //     // Remove "ref" from the parameters
  //     parameters: element.parameters.skip(1).toList(),
  //     valueDisplayType:
  //         _getUserModelType(element).getDisplayString(withNullability: true),
  //     dependencies: dependencies(riverpod),
  //   );
  // }

  bool _isBuildAsync(FunctionTypedElement element) {
    return element.returnType.isDartAsyncFutureOr ||
        element.returnType.isDartAsyncFuture;
  }

  DartType _getUserModelType(ExecutableElement element) {
    final isAsync = element.returnType.isDartAsyncFuture ||
        element.returnType.isDartAsyncFutureOr;

    if (!isAsync) return element.returnType;

    final returnType = element.returnType as InterfaceType;
    return returnType.typeArguments.single;
  }

  // ProviderDependencies dependencies(DartObject riverpodAnnotation) {
  //   final dependencies =
  //       riverpodAnnotation.getField('dependencies')?.toListValue();
  //   if (dependencies == null) return ProviderDependencies(null);

  //   return ProviderDependencies(
  //     dependencies.map<ProviderDependency>((entry) {
  //       if (entry.type?.isDartCoreString ?? false) {
  //         // dependencies: ["string"]
  //         return StringProviderDependency(entry.toStringValue()!);
  //       } else if (entry.type != null && entry.toFunctionValue() != null) {
  //         // @riverpod
  //         // function(ref) {...}
  //         //
  //         // @Riverpod(dependencies: [function])
  //         return ReferenceProviderDependency(
  //           '${entry.toFunctionValue()!.displayName}Provider',
  //         );
  //       } else if (entry.toTypeValue() != null) {
  //         // @riverpod
  //         // class Class {...}
  //         //
  //         // @Riverpod(dependencies: [Class])
  //         return ReferenceProviderDependency(
  //           '${entry.toTypeValue()?.getDisplayString(withNullability: false).camelCase}Provider',
  //         );
  //       }

  //       throw InvalidGenerationSourceError(
  //         'Unsupported dependency. Only Strings or elements annotated by @riverpod are supported.',
  //         element: entry.variable,
  //       );
  //     }).toList(),
  //   );
  // }

  // FutureOr<Data> _parseClassElement(
  //   BuildStep buildStep,
  //   GlobalData globalData,
  //   ClassElement element,
  // ) async {
  //   final riverpod = riverpodType.firstAnnotationOf(element)!;

  //   // TODO check has default constructor with no param.

  //   final buildMethod = element.methods.firstWhere(
  //     (element) => element.name == 'build',
  //     orElse: () => throw InvalidGenerationSourceError(
  //       'Provider classes must contain a method named `build`.',
  //       element: element,
  //     ),
  //   );

  //   return Data.notifier(
  //     createAst: (await buildStep.resolver.astNodeFor(element, resolve: true))!,
  //     createElement: buildMethod,
  //     providerDoc: element.documentationComment == null
  //         ? '/// See also [${element.name}].'
  //         : '${element.documentationComment}\n///\n/// Copied from [${element.name}].',
  //     keepAlive: _getKeepAlive(riverpod),
  //     rawName: element.name,
  //     notifierName: element.name,
  //     isScoped: buildMethod.isAbstract,
  //     // No "ref" on build, therefore any parameter = family
  //     isFamily: buildMethod.parameters.isNotEmpty,
  //     isAsync: _isBuildAsync(buildMethod),
  //     parameters: buildMethod.parameters,
  //     valueDisplayType: _getUserModelType(buildMethod)
  //         .getDisplayString(withNullability: true),
  //     dependencies: dependencies(riverpod),
  //   );
  // }

  @override
  Iterable<Object> generateForAll(GlobalData globalData) sync* {
    yield '''
// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}
''';
    yield '''
List<ProviderOrFamily> _allTransitiveDependencies(
  List<ProviderOrFamily> dependencies,
) {
  final result = <ProviderOrFamily>{};

  void visitDependency(ProviderOrFamily dep) {
    if (result.add(dep) && dep.dependencies != null) {
      dep.dependencies!.forEach(visitDependency);
    }
    final depFamily = dep.from;
    if (depFamily != null &&
        result.add(depFamily) &&
        depFamily.dependencies != null) {
      depFamily.dependencies!.forEach(visitDependency);
    }
  }

  dependencies.forEach(visitDependency);

  return List.unmodifiable(result);
}
''';
  }

  @override
  Iterable<Object> generateForData(
    GlobalData globalData,
    GeneratorProviderDefinition data,
  ) sync* {
    yield RefTemplate(data);
    yield HashTemplate(data, globalData.hash);
    yield ProviderTemplate(data);

    if (data.parameters.isNotEmpty) {
      yield FamilyTemplate(data);
    }
    if (data.isNotifier) {
      yield NotifierTemplate(data);
    }
  }
}
