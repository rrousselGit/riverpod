import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';

@immutable
class RiverpodGenerator extends ParserGenerator<GlobalData, Data, Atom> {
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
    print('here');
    // if (element is! ClassElement) {
    //   throw InvalidGenerationSourceError(
    //     '@freezed can only be applied on classes. Failing element: ${element.name}',
    //     element: element,
    //   );
    // }

    return Data();
  }

  @override
  Iterable<Object> generateForData(
    GlobalData globalData,
    Data data,
  ) sync* {
    print('hey');
    yield '''
class HelloWorld {}
''';
  }
}
