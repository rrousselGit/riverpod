import 'dart:io';

import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:build/build.dart';
import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:source_gen/source_gen.dart' hide TypeChecker;

/// Builds generators for `build_runner` to run
Builder riverpodDevtoolGenerator(BuilderOptions options) {
  return SharedPartBuilder([
    _RiverpodDevtoolGeneratorGenerator(),
  ], 'riverpod_devtool_generator');
}

class _RiverpodDevtoolGeneratorGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final annotatedClasses = library.element.firstFragment.importedLibraries2
        .expand((e) => e.exportNamespace.definedNames2.values)
        .whereType<Annotatable>()
        .where((e) {
          return e.metadata2.annotations.any((e) {
            return e.toSource().contains('devtool');
          });
        })
        .whereType<ClassElement2>()
        .toList();
    if (annotatedClasses.isEmpty) return '';

    if (buildStep.inputId.pathSegments.last == 'event.dart') {
      return _generateDevtoolChannel(library, buildStep, annotatedClasses);
    } else if (buildStep.inputId.pathSegments.last == 'framework.dart') {
      return _generateCodeExtension(library, buildStep, annotatedClasses);
    } else {
      return '';
    }
  }

  String _generateCodeExtension(
    LibraryReader library,
    BuildStep buildStep,
    List<ClassElement2> annotatedClasses,
  ) {
    final buffer = AnalyzerBuffer.part2(library.element);

    for (final clazz in annotatedClasses) {
      buffer.write(
        args: {
          'code': () {
            if (clazz.isSealed) {
              final subclasses = annotatedClasses.where(
                (e) => e.allSupertypes.contains(clazz.thisType),
              );

              buffer.write(
                args: {
                  'cases': () {
                    for (final subclass in subclasses) {
                      buffer.write(
                        'case ${subclass.name3}(): return that.toBytes(path: path);',
                      );
                    }
                  },
                },
                '''
final that = this;
switch (that) {
  #{{cases}}
}
''',
              );
            } else {
              final res = _varName('res');
              buffer.write(
                "final $res = <String, Object?>{'\$path._type': '${clazz.name3}'};\n",
              );

              for (final field in clazz.fields2) {
                final type = _BuiltInType.from(
                  field.type,
                  annotatedClasses: annotatedClasses,
                );

                buffer.write(
                  '${type.appendEncodedValueCode(mapSymbol: res, valueSymbol: field.name3!, path: '\$path.${field.name3!}')}\n',
                );
              }

              buffer.write('return $res;\n');
            }
          },
        },
        '''
@internal
extension ${clazz.name3}ToBytes on ${clazz.name3} {
  Map<String, Object?> toBytes({
    required String path
  }) {
    #{{code}}
  }
}
''',
      );
    }

    return buffer.toString();
  }

  String _generateDevtoolChannel(
    LibraryReader library,
    BuildStep buildStep,
    List<ClassElement2> annotatedClasses,
  ) {
    final buffer = AnalyzerBuffer.part2(library.element);

    final sealedClasses = annotatedClasses.where((e) => e.isSealed).toList();
    final subClasses = annotatedClasses.where((e) => !e.isSealed).toList();

    for (final root in sealedClasses) {
      final subclasses = subClasses
          .where((e) => e.allSupertypes.contains(root.thisType))
          .toList();

      buffer.write(
        args: {
          'case': () {
            buffer.write(
              subclasses
                  .map((e) {
                    return '''
                case '${e.name3}':
                  return ${e.name3}.from(events, path: path);
                ''';
                  })
                  .join('\n'),
            );
          },
        },
        '''
/// Devtool code for [${root.thisType.toCode()}]
sealed class ${root.name3} {
  ${root.name3}();

  factory ${root.name3}.from(Map<String, Byte> events, {required String path}) {
    final type = events['\$path._type']!.ref.valueAsString;

    switch (type) {
      #{{case}}
      default:
        throw ArgumentError('Unknown event type: \$type');
    }
  }
}
''',
      );
    }

    for (final leaf in subClasses) {
      _writeSubclass(buffer, leaf, annotatedClasses: annotatedClasses);
    }

    return buffer.toString();
  }

  void _writeSubclass(
    AnalyzerBuffer buffer,
    ClassElement2 subclass, {
    required List<ClassElement2> annotatedClasses,
  }) {
    final fields = subclass.fields2
        .map(
          (e) => (
            name: e.name3!,
            type: _BuiltInType.from(e.type, annotatedClasses: annotatedClasses),
          ),
        )
        .toList();

    buffer.write(
      args: {
        'defaultCtor': () => buffer.write('''
        ${subclass.name3}({
          ${fields.map((e) => 'required this.${e.name},').join()}
        });
        '''),
        'ctorParameters': () {
          for (final field in fields) {
            buffer.write('''
final ${field.name} = ${field.type.decodeBytes(mapSymbol: r'$events', path: '\$path.${field.name}')};
''');
          }
        },
        'fromCtor': () {
          buffer.write('''
        factory ${subclass.name3}.from(
          Map<String, Byte> \$events, {
          required String path,
        }) {
          _validate(
            \$events,
            name: '${subclass.name3}',
            path: path,
          );

          #{{ctorParameters}}
        
          return ${subclass.name3}(
            ${fields.map((e) => '  ${e.name}: ${e.name},').join('\n')}
          );
        }
        ''');
        },
        'fields': () => buffer.write(
          fields
              .map((e) => '  final ${e.type.typeCode()} ${e.name};')
              .join('\n'),
        ),
        'superClass': () {
          if (!subclass.supertype!.isDartCoreObject) {
            buffer.write('extends ${subclass.supertype!.element3.name3}');
          }
        },
      },
      '''
/// Devtool code for [${subclass.thisType.toCode()}]
class ${subclass.name3} #{{superClass}} {
  #{{defaultCtor}}
  #{{fromCtor}}
  #{{fields}}
}
''',
    );
  }
}

final _format = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
);

String formatStatement(String code) {
  try {
    final res = _format.formatStatement('$code;').trim();
    return res.substring(0, res.length - 1);
  } catch (_) {
    // If formatting fails, return the unformatted code
    exitCode = 1;
    stderr.writeln('Warning: could not format generated code:\n$code');
    return code;
  }
}

sealed class _BuiltInType {
  static _BuiltInType from(
    DartType type, {
    required List<ClassElement2> annotatedClasses,
  }) {
    const dateTimeChecker = TypeChecker.fromName(
      'DateTime',
      packageName: 'dart:core',
    );

    const internalsUri = 'package:riverpod/src/internals.dart';
    const containerIdChecker = TypeChecker.fromName(
      'ContainerId',
      packageName: internalsUri,
    );
    const providerIdChecker = TypeChecker.fromName(
      'ProviderId',
      packageName: internalsUri,
    );
    const originIdChecker = TypeChecker.fromName(
      'OriginId',
      packageName: internalsUri,
    );

    if (annotatedClasses.any((e) => e.name3 == type.element3?.name3)) {
      return _OtherDevtoolType(type);
    } else if (containerIdChecker.isExactlyType(type)) {
      return _ContainerId();
    } else if (providerIdChecker.isExactlyType(type)) {
      return _ProviderId();
    } else if (originIdChecker.isExactlyType(type)) {
      return _OriginId();
    } else if (type.isDartCoreList) {
      final listType = type as InterfaceType;
      return _ListType(
        from(listType.typeArguments.single, annotatedClasses: annotatedClasses),
      );
    } else if (type.isDartCoreString) {
      return _StringType();
    } else if (type.isDartCoreInt) {
      return _IntType();
    } else if (type.isDartCoreDouble) {
      return _DoubleType();
    } else if (type.isDartCoreBool) {
      return _BoolType();
    } else if (dateTimeChecker.isExactlyType(type)) {
      return _DateTimeType();
    } else {
      return _UnknownType(type);
    }
  }

  @useResult
  String typeCode();
  @useResult
  String decodeBytes({required String mapSymbol, required String path});
  @useResult
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  });
}

final class _IdType extends _BuiltInType {
  _IdType(this.typeName);

  final String typeName;
  @override
  String typeCode() => '#{{riverpod/src/internals.dart|$typeName}}';

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "#{{riverpod/src/internals.dart|$typeName}}($mapSymbol['$path']!.ref.valueAsString!)";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) => "$mapSymbol['$path'] = $valueSymbol;";
}

final class _ContainerId extends _IdType {
  _ContainerId() : super('ContainerId');
}

final class _ProviderId extends _IdType {
  _ProviderId() : super('ProviderId');
}

final class _OriginId extends _IdType {
  _OriginId() : super('OriginId');
}

final class _ListType extends _BuiltInType {
  _ListType(this.innerType);

  final _BuiltInType innerType;

  @override
  String typeCode() => '#{{dart:core|List}}<${innerType.typeCode()}>';

  @override
  String decodeBytes({required String mapSymbol, required String path}) {
    return '''
    List.generate(
      int.parse($mapSymbol['$path.length']!.ref.valueAsString!),
      (i) {
        return ${innerType.decodeBytes(mapSymbol: mapSymbol, path: '$path[\$i]')};
      },
    )
    ''';
  }

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) {
    return '''
  {
    $mapSymbol['$path.length'] = $valueSymbol.length;
    for (final (index, e) in $valueSymbol.indexed) {
      ${innerType.appendEncodedValueCode(mapSymbol: mapSymbol, valueSymbol: 'e', path: '$path[\$index]')}
    }
  }
  ''';
  }
}

final class _StringType extends _BuiltInType {
  @override
  String typeCode() => '#{{dart:core|String}}';

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "$mapSymbol['$path']!.valueAsString!";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) => "$mapSymbol['$path'] = $valueSymbol;";
}

final class _IntType extends _BuiltInType {
  @override
  String typeCode() => '#{{dart:core|int}}';

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "int.parse($mapSymbol['$path']!.ref.valueAsString!)";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) => "$mapSymbol['$path'] = $valueSymbol;";
}

final class _DoubleType extends _BuiltInType {
  @override
  String typeCode() => '#{{dart:core|double}}';

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "double.parse($mapSymbol['$path']!.ref.valueAsString!)";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) => "$mapSymbol['$path'] = $valueSymbol;";
}

final class _BoolType extends _BuiltInType {
  @override
  String typeCode() => '#{{dart:core|bool}}';

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "($mapSymbol['$path']!.ref.valueAsString! == 'true')";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) => "$mapSymbol['$path'] = $valueSymbol;";
}

final class _DateTimeType extends _BuiltInType {
  @override
  String typeCode() => '#{{dart:core|DateTime}}';

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "DateTime.fromMillisecondsSinceEpoch(int.parse($mapSymbol['$path']!.ref.valueAsString!))";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) => "$mapSymbol['$path'] = $valueSymbol.millisecondsSinceEpoch;";
}

final class _OtherDevtoolType extends _BuiltInType {
  _OtherDevtoolType(this.type);

  final DartType type;

  @override
  String typeCode() => type.element3!.name3!;

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "${type.element3!.name3!}.from($mapSymbol, path: '$path')";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) =>
      "$mapSymbol.addAll(${type.element3!.name3}ToBytes($valueSymbol).toBytes(path: '$path'));";
}

final class _UnknownType extends _BuiltInType {
  _UnknownType(this.type);

  final DartType type;

  @override
  String typeCode() => '#{{vm_service|InstanceRef}}';

  @override
  String decodeBytes({required String mapSymbol, required String path}) =>
      "$mapSymbol['$path']!.ref";

  @override
  String appendEncodedValueCode({
    required String mapSymbol,
    required String valueSymbol,
    required String path,
  }) => "$mapSymbol['$path'] = $valueSymbol;";
}

int _varCount = 0;
String _varName([String key = 'r']) => '$key${_varCount++}';
