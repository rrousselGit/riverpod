import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';
import 'riverpod_generator.dart';
import 'type.dart';

@immutable
class JsonGenerator extends ParserGenerator<JsonPersist> {
  @override
  FutureOr<String> generateForUnit(List<CompilationUnit> compilationUnits) {
    final buffer = StringBuffer();

    for (final unit in compilationUnits.expand((e) => e.declarations)) {
      final provider = unit.provider;

      if (provider is! ClassBasedProviderDeclaration || !provider.isPersisted) {
        // Noop, we only care about persisted notifiers
        continue;
      }

      final hasAnnotation = provider.node.metadata.any(
        (e) => e.annotationOfType(jsonPersistType, exact: true) != null,
      );
      // Not annotated by @JsonPersist
      if (!hasAnnotation) continue;

      _generateNotifier(buffer, provider);
    }

    return buffer.toString();
  }

  void _generateNotifier(
    StringBuffer buffer,
    ClassBasedProviderDeclaration provider,
  ) {
    if (provider.node.typeParameters?.typeParameters.isNotEmpty ?? false) {
      throw InvalidGenerationSourceError(
        'Encoding generic notifiers is currently not supported',
        element: provider.node.declaredElement,
        node: provider.node,
      );
    }

    final baseClass = '_\$${provider.name.lexeme.public}Base';
    final notifierClass = '_\$${provider.name.lexeme.public}';

    final genericsDefinition = provider.genericsDefinition();

    final valueString = switch (provider.createdType) {
      SupportedCreatedType.future ||
      SupportedCreatedType.stream =>
        'state.requireValue',
      SupportedCreatedType.value => 'state',
    };

    final key = !provider.providerElement.isFamily
        ? '=> ${provider.name};'
        : '''
  {
    final args = ${provider.argumentToRecord()};
    return '${provider.name}(\$args)';
  }''';

    String decode(DartType type) {
      var result = type.switchPrimitiveType(
        boolean: () => 'e as bool',
        integer: () => 'e as int',
        double: () => 'e as double',
        number: () => 'e as num',
        string: () => 'e as String',
        array: (item) {
          return '(e as List).map((e) => ${decode(item)}).toList()';
        },
        set: (item) {
          return '(e as List).map((e) => ${decode(item)}).toSet()';
        },
        map: (key, value) {
          return '(e as Map).map((k, v) => MapEntry(${decode(key)}, ${decode(value)}))';
        },
        object: () {
          return '${type.getDisplayString()}.fromJson(e)';
        },
      );

      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        result = 'e == null ? null : $result';
      }

      return result;
    }

    final decoded = decode(provider.valueTypeNode!.type!);

    buffer.writeln(
      '''
abstract class $notifierClass$genericsDefinition
    extends $baseClass
    with NotifierEncoder<String, ${provider.valueTypeDisplayString}, String> {
  @override
  String get persistKey $key

  @override
  String encode() {
    return \$jsonCodex.encode($valueString);
  }

  @override
  ${provider.valueTypeDisplayString} decode(String value) {
    final e = \$jsonCodex.decode(value);
    return $decoded;
  }
}''',
    );
  }
}

extension on DartType {
  R switchPrimitiveType<R>({
    required R Function() boolean,
    required R Function() integer,
    required R Function() double,
    required R Function() number,
    required R Function() string,
    required R Function(DartType item) array,
    required R Function(DartType item) set,
    required R Function(DartType key, DartType value) map,
    required R Function() object,
  }) {
    if (isDartCoreBool) {
      return boolean();
    } else if (isDartCoreInt) {
      return integer();
    } else if (isDartCoreDouble) {
      return double();
    } else if (isDartCoreNum) {
      return number();
    } else if (isDartCoreString) {
      return string();
    } else if (isDartCoreSet) {
      return set(typeArguments!.single);
    } else if (isDartCoreList) {
      return array(typeArguments!.single);
    } else if (isDartCoreMap) {
      final typeArgs = typeArguments!;
      return map(typeArgs[0], typeArgs[1]);
    } else {
      return object();
    }
  }

  List<DartType>? get typeArguments {
    final that = this;
    if (that is InterfaceType) {
      return that.typeArguments;
    }
    return null;
  }
}
