import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart' show Ref;
// ignore: implementation_imports, safe as we are the one controlling this file
import 'package:riverpod_annotation/src/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';
import 'templates/provider.dart';
import 'templates/ref.dart';

const _refTypeChecker = TypeChecker.fromRuntime(Ref);

@immutable
class RiverpodGenerator extends ParserGenerator<GlobalData, Data, Provider> {
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
        '@provider can only be applied on functions and classes. Failing element: ${element.name}',
        element: element,
      );
    }
  }

  FutureOr<Data> _parseFunctionElement(
    BuildStep buildStep,
    GlobalData globalData,
    FunctionElement element,
  ) {
    final providerName = _providerNameFor(element);

    final refParam = element.parameters.firstOrNull;
    // TODO test & check unknown type
    if (refParam == null || _refTypeChecker.isAssignableFrom(refParam)) {
      throw InvalidGenerationSourceError(
        'The build function of providers must receive a `Ref` as parameter.',
        element: element,
      );
    }
    final refType = (refParam.type as InterfaceType).typeArguments.singleOrNull;
    if (refType == null || (refType.element?.isSynthetic ?? false)) {
      throw InvalidGenerationSourceError(
        'The `Ref` of providers must specify its generic parameter. Example: `Ref<String>`',
        element: element,
      );
    }

    return Data.function(
      isScoped: element.isExternal,
      isAsync: _isBuildAsync(element),
      functionName: element.name,
      providerName: providerName,
      refName: '${providerName}Ref',
      providerType: ProviderType.provider,
      valueDisplayType: refType.getDisplayString(withNullability: true),
    );
  }

  bool _isBuildAsync(FunctionTypedElement element) {
    return element.returnType.isDartAsyncFuture ||
        element.returnType.isDartAsyncFuture;
  }

  String _providerNameFor(Element element) {
    final name = element.name ?? '';
    if (!name.startsWith('_')) {
      throw InvalidGenerationSourceError(
        'The name of providers must start with a `_`',
        element: element,
      );
    }

    // __provider -> _Provider
    // _provider -> Provider
    return name.substring(1).replaceFirstMapped(
          RegExp('[a-zA-Z]'),
          (match) => match.group(0)!.toUpperCase(),
        );
  }

  FutureOr<Data> _parseClassElement(
    BuildStep buildStep,
    GlobalData globalData,
    ClassElement element,
  ) {
    // __provider -> _Provider
    // _provider -> Provider
    final providerName = _providerNameFor(element);

    // TODO check has default constructor with no param.

    final buildMethod = element.methods.firstWhere(
      (element) => element.name == 'build',
      orElse: () => throw InvalidGenerationSourceError(
        'Provider classes must contain a method named `build`.',
        element: element,
      ),
    );

    final refParam = buildMethod.parameters.firstOrNull;
    // TODO test & check unknown type
    if (refParam == null || _refTypeChecker.isAssignableFrom(refParam)) {
      throw InvalidGenerationSourceError(
        'The build method of provider classes must receive a `Ref` as parameter.',
        element: element,
      );
    }
    final refType = (refParam.type as InterfaceType).typeArguments.singleOrNull;
    if (refType == null || (refType.element?.isSynthetic ?? false)) {
      throw InvalidGenerationSourceError(
        'The `Ref` of providers must specify its generic parameter. Example: `Ref<String>`',
        element: element,
      );
    }

    return Data.notifier(
      isScoped: buildMethod.isAbstract,
      isAsync: _isBuildAsync(buildMethod),
      notifierName: element.name,
      providerName: providerName,
      refName: '${providerName}Ref',
      providerType: ProviderType.provider,
      valueDisplayType: refType.getDisplayString(withNullability: true),
    );
  }

  @override
  Iterable<Object> generateForData(
    GlobalData globalData,
    Data data,
  ) sync* {
    yield ProviderTemplate(data);
    yield RefTemplate(data);
  }
}
