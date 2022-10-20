import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:meta/meta.dart';
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

const riverpodTypeChecker = TypeChecker.fromRuntime(Riverpod);

@immutable
// ignore: invalid_use_of_internal_member
class RiverpodGenerator extends ParserGenerator<GlobalData, Data, Riverpod> {
  RiverpodGenerator(this.configs);

  final Map<String, Object?> configs;

  @override
  GlobalData parseGlobalData(LibraryElement library) {
    return GlobalData();
  }

  @override
  FutureOr<Data> parseElement(
    BuildStep buildStep,
    GlobalData globalData,
    Element element,
  ) async {
    if (element is FunctionElement) {
      return _parseFunctionElement(buildStep, globalData, element);
    } else if (element is ClassElement) {
      return _parseClassElement(buildStep, globalData, element);
    } else {
      throw InvalidGenerationSourceError(
        '@riverpod can only be applied on functions and classes. Failing element: ${element.name}',
        element: element,
      );
    }
  }

  bool _getKeepAlive(DartObject element) {
    return element.getField('keepAlive')?.toBoolValue() ?? false;
  }

  FutureOr<Data> _parseFunctionElement(
    BuildStep buildStep,
    GlobalData globalData,
    FunctionElement element,
  ) async {
    final riverpod = riverpodTypeChecker.firstAnnotationOf(element)!;

    return Data.function(
      createElement: element,
      createAst: (await buildStep.resolver.astNodeFor(element, resolve: true))!,
      providerDoc: element.documentationComment == null
          ? '/// See also [${element.name}].'
          : '${element.documentationComment}\n///\n/// Copied from [${element.name}].',
      rawName: element.name,
      keepAlive: _getKeepAlive(riverpod),
      isScoped: element.isExternal,
      // functional providers have a "ref" has paramter, so families have at
      // least 2 parameters.
      isFamily: element.parameters.length > 1,
      isAsync: _isBuildAsync(element),
      functionName: element.name,
      // Remove "ref" from the parameters
      parameters: element.parameters.skip(1).toList(),
      valueDisplayType:
          _getUserModelType(element).getDisplayString(withNullability: true),
    );
  }

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

  FutureOr<Data> _parseClassElement(
    BuildStep buildStep,
    GlobalData globalData,
    ClassElement element,
  ) async {
    final riverpod = riverpodTypeChecker.firstAnnotationOf(element)!;

    // TODO check has default constructor with no param.

    final buildMethod = element.methods.firstWhere(
      (element) => element.name == 'build',
      orElse: () => throw InvalidGenerationSourceError(
        'Provider classes must contain a method named `build`.',
        element: element,
      ),
    );

    return Data.notifier(
      createAst: (await buildStep.resolver.astNodeFor(element, resolve: true))!,
      createElement: buildMethod,
      providerDoc: element.documentationComment == null
          ? '/// See also [${element.name}].'
          : '${element.documentationComment}\n///\n/// Copied from [${element.name}].',
      keepAlive: _getKeepAlive(riverpod),
      rawName: element.name,
      notifierName: element.name,
      isScoped: buildMethod.isAbstract,
      // No "ref" on build, therefore any parameter = family
      isFamily: buildMethod.parameters.isNotEmpty,
      isAsync: _isBuildAsync(buildMethod),
      parameters: buildMethod.parameters,
      valueDisplayType: _getUserModelType(buildMethod)
          .getDisplayString(withNullability: true),
    );
  }

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
  }

  @override
  Iterable<Object> generateForData(
    GlobalData globalData,
    Data data,
  ) sync* {
    yield HashTemplate(data, globalData.hash);
    yield ProviderTemplate(data);
    yield RefTemplate(data);

    if (data.isFamily) {
      yield FamilyTemplate(data);
    }
    if (data.isNotifier) {
      yield NotifierTemplate(data);
    }
  }
}
