import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports, safe as we are the one controlling this file
import 'package:riverpod_annotation/src/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';
import 'templates/provider.dart';
import 'templates/ref.dart';

@immutable
class RiverpodGenerator extends ParserGenerator<GlobalData, Data, Provider> {
  RiverpodGenerator(this.configs);

  final Map<String, Object?> configs;

  @override
  GlobalData parseGlobalData(LibraryElement library) {
    return GlobalData();
  }

  @override
  Future<Data> parseElement(
    BuildStep buildStep,
    GlobalData globalData,
    Element element,
  ) async {
    if (element is! FunctionElement) {
      throw InvalidGenerationSourceError(
        '@provider can only be applied on functions. Failing element: ${element.name}',
        element: element,
      );
    }

    // __provider -> _Provider
    // _provider -> Provider
    final providerName = element.name.substring(1).replaceFirstMapped(
          RegExp('[a-zAZ]'),
          (match) => match.group(0)!.toUpperCase(),
        );

    return Data(
      providerName: providerName,
      refName: '${providerName}Ref',
      providerType: ProviderType.provider,
      valueDisplayType:
          element.returnType.getDisplayString(withNullability: true),
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
