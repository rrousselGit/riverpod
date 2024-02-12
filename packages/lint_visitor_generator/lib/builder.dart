import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart' hide TypeChecker;

import 'src/type_checker.dart';

/// Builds generators for `build_runner` to run
Builder lintVisitorGenerator(BuilderOptions options) {
  return SharedPartBuilder(
    [_LintVisitorGenerator()],
    'lint_visitor_generator',
  );
}

const _riverpodAstType = TypeChecker.fromName(
  'RiverpodAst',
  packageName: 'riverpod_analyzer_utils',
);

sealed class _AstField {
  _AstField({required this.field, required this.type});

  static _AstField? parse(FieldElement field) {
    if (field.type.isDartCoreList) {
      final valueType = (field.type as InterfaceType).typeArguments.single;
      if (!_riverpodAstType.isAssignableFromType(valueType)) return null;

      return _ListAstField(
        field: field,
        type: field.type,
        valueType: valueType,
      );
    } else {
      if (!_riverpodAstType.isAssignableFromType(field.type)) return null;
      return _SingleAstField(field: field, type: field.type);
    }
  }

  final FieldElement field;
  final DartType type;
}

class _ListAstField extends _AstField {
  _ListAstField({
    required super.field,
    required super.type,
    required this.valueType,
  });

  final DartType valueType;
}

class _SingleAstField extends _AstField {
  _SingleAstField({
    required super.field,
    required super.type,
  });
}

class _LintVisitorGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();
    if (library.element.name == 'riverpod_ast') {
      _writeRiverpodAstVisitor(library, buffer);
    }

    if (buffer.isNotEmpty) {
      buffer.writeln('// ignore_for_file: type=lint');
    }

    return buffer.toString();
  }

  void _writeRiverpodAstVisitor(LibraryReader library, StringBuffer buffer) {
    final allAst = library.classes
        .where((e) => e.name != 'RiverpodAst')
        .where(_riverpodAstType.isAssignableFrom)
        .toList();

    final relationships = <ClassElement, List<String>>{};

    for (final ast in allAst) {
      final relation = relationships.putIfAbsent(ast, () => []);

      String? supertype;
      if (ast.supertype case final type?
          when !type.isDartCoreObject && type.element.name != 'RiverpodAst') {
        supertype = type.element.name;
        relation.add(supertype);
      }

      final astFields = ast.fields.map(_AstField.parse).whereNotNull().toList();

      _writeAstMixin(buffer, ast, supertype, astFields);
    }

    final concreteRelationshipEntries =
        relationships.entries.where((e) => !e.key.isAbstract);

    buffer.writeln('''
abstract class RiverpodAstVisitor {
  ${concreteRelationshipEntries.map(
              (e) => '''
  void visit${e.key.name}(${e.key.name} node);
''',
            ).join('\n')}
}

abstract class GeneralizingRiverpodAstVisitor implements RiverpodAstVisitor {
  void visitRiverpodAst(RiverpodAst node) {
    node.visitChildren(this);
  }
  
  ${relationships.entries.map(
              (e) => '''
  ${e.key.isAbstract ? '' : '@override'}
  void visit${e.key.name}(${e.key.name} node) {
    ${e.value.map((e) => 'visit$e(node);').join('\n')}
  }
''',
            ).join('\n')}
}


abstract class RecursiveRiverpodAstVisitor implements RiverpodAstVisitor {
  ${concreteRelationshipEntries.map(
              (e) => '''
  @override
  void visit${e.key.name}(${e.key.name} node) {
    node.visitChildren(this);
  }
''',
            ).join('\n')}
}

abstract class SimpleRiverpodAstVisitor implements RiverpodAstVisitor {
  ${concreteRelationshipEntries.map(
              (e) => '''
  @override
  void visit${e.key.name}(${e.key.name} node) {
  }
''',
            ).join('\n')}
}

abstract class UnimplementedRiverpodAstVisitor implements RiverpodAstVisitor {
  ${concreteRelationshipEntries.map(
              (e) => '''
  @override
  void visit${e.key.name}(${e.key.name} node) {
    throw UnimplementedError();
  }
''',
            ).join('\n')}
}

class _RiverpodAstRegistryVisitor extends GeneralizingRiverpodAstVisitor {
  _RiverpodAstRegistryVisitor(this._registry);

  final RiverpodAstRegistry _registry;

  void _runSubscriptions<R>(
    R value,
    List<void Function(R)> subscriptions,
  ) {
    for (final sub in subscriptions) {
      try {
        sub(value);
      } catch (e, stack) {
        Zone.current.handleUncaughtError(e, stack);
      }
    }
  }

  @override
  void visitRiverpodAst(RiverpodAst node) {
    node.visitChildren(this);
  }
  
  ${relationships.entries.map(
              (e) => '''
  @override
  void visit${e.key.name}(${e.key.name} node) {
    super.visit${e.key.name}(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._on${e.key.name},
    );
  }

''',
            ).join('\n')}
}

class RiverpodAstRegistry {
  void run(RiverpodAst node) {
    node.accept(_RiverpodAstRegistryVisitor(this));
  }

  final _onRiverpodAst = <void Function(RiverpodAst)>[];
  void addRiverpodAst(void Function(RiverpodAst node) cb) {
    _onRiverpodAst.add(cb);
  }
  
  ${relationships.entries.map(
              (e) => '''
  final _on${e.key.name} = <void Function(${e.key.name})>[];
  void add${e.key.name}(void Function(${e.key.name} node) cb) {
    _on${e.key.name}.add(cb);
  }
''',
            ).join('\n')}
}
''');
  }

  void _writeAstMixin(
    StringBuffer buffer,
    ClassElement ast,
    String? supertype,
    List<_AstField> astFields,
  ) {
    late final accept = '''
      @override
      void accept(RiverpodAstVisitor visitor) {
        visitor.visit${ast.name}(this as ${ast.name},);
      }
    ''';

    final visitChildren = StringBuffer();
    if (supertype != null) {
      visitChildren.writeln('super.visitChildren(visitor);');
    }

    for (final field in astFields) {
      switch (field) {
        case _ListAstField():
          final op =
              field.valueType.nullabilitySuffix == NullabilitySuffix.question
                  ? '?'
                  : '';

          var leading = '';
          var trailing = '';
          if (field.type.nullabilitySuffix == NullabilitySuffix.question) {
            leading =
                'if (${field.field.name} case final ${field.field.name}?) {';
            trailing = '}';
          }

          visitChildren.writeln('''
              $leading
              for (final value in ${field.field.name}) {
                value$op.accept(visitor);
              }
              $trailing
            ''');

        case _SingleAstField():
          final op = field.type.nullabilitySuffix == NullabilitySuffix.question
              ? '?'
              : '';
          visitChildren.writeln(
            '${field.field.name}$op.accept(visitor);',
          );
      }
    }

    buffer.writeln('''
mixin _\$${ast.name} on ${supertype ?? 'RiverpodAst'} {
  ${astFields.map((e) => '${e.type} get ${e.field.name};').join('\n')}

  ${ast.isAbstract ? '' : accept}

  @override void visitChildren(RiverpodAstVisitor visitor) {
    $visitChildren
  }
}
''');
  }
}
