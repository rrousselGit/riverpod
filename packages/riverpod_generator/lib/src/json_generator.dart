import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:source_gen/source_gen.dart';

import 'parse_generator.dart';
import 'riverpod_generator.dart';

@immutable
class JsonGenerator extends ParserGenerator<JsonPersist> {
  @override
  FutureOr<String> generateForUnit(List<CompilationUnit> compilationUnits) {
    if (compilationUnits.isEmpty) return '';

    final buffer = AnalyzerBuffer.part2(
      compilationUnits.first.declaredFragment!.element,
    );

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
    AnalyzerBuffer buffer,
    ClassBasedProviderDeclaration provider,
  ) {
    if (provider.node.typeParameters?.typeParameters.isNotEmpty ?? false) {
      throw InvalidGenerationSourceError(
        'Encoding generic notifiers is currently not supported',
        element: provider.node.declaredFragment!.libraryFragment.element.classes
            .where((e) => e.name3 == provider.name.lexeme)
            .firstOrNull,
        node: provider.node,
      );
    }

    final baseClass = '_\$${provider.name.lexeme.public}Base';
    final notifierClass = '_\$${provider.name.lexeme.public}';

    final genericsDefinition = provider.genericsDefinition();

    final resolvedKey = !provider.providerElement.isFamily
        ? 'const resolvedKey = "${provider.name}";'
        : '''
    late final args = ${provider.argumentToRecord()};
    late final resolvedKey = '${provider.name}(\$args)';
''';

    String decode(DartType type, String name) {
      var result = type.switchPrimitiveType(
        boolean: () => '$name as bool',
        integer: () => '$name as int',
        double: () => '$name as double',
        number: () => '$name as num',
        string: () => '$name as String',
        array: (item) {
          return '($name as List).map((e) => ${decode(item, 'e')}).toList()';
        },
        set: (item) {
          return '($name as List).map((e) => ${decode(item, 'e')}).toSet()';
        },
        map: (key, value) {
          return '($name as Map).map((k, v) => MapEntry(${decode(key, 'k')}, ${decode(value, 'v')}))';
        },
        object: () {
          return '${type.getDisplayString()}.fromJson($name as Map<String, Object?>)';
        },
      );

      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        result = '$name == null ? null : $result';
      }

      return result;
    }

    final decoded = decode(provider.providerElement.valueTypeNode, 'e');

    buffer.write(
      '''
abstract class $notifierClass$genericsDefinition extends $baseClass {
  /// The default key used by [persist].
  String get key {
    $resolvedKey
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  PersistResult persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(${provider.providerElement.valueTypeNode.toCode()} state)? encode,
    ${provider.providerElement.valueTypeNode.toCode()} Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? \$jsonCodex.encode,
      decode: decode ?? (encoded) {
        final e = \$jsonCodex.decode(encoded);
        return $decoded;
      },
      options: options,
    );
  }
}
''',
    );
  }
}

extension on DartType {
  ResT switchPrimitiveType<ResT>({
    required ResT Function() boolean,
    required ResT Function() integer,
    required ResT Function() double,
    required ResT Function() number,
    required ResT Function() string,
    required ResT Function(DartType item) array,
    required ResT Function(DartType item) set,
    required ResT Function(DartType key, DartType value) map,
    required ResT Function() object,
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
