// ignore: deprecated_member_use
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:codemod/codemod.dart';

/// A suggestor that yields changes to deprecated import directives
class RiverpodImportAllMigrationSuggestor extends GeneralizingAstVisitor<void>
    with AstVisitingSuggestor {
  @override
  bool shouldResolveAst(FileContext context) => true;
  @override
  void visitImportDirective(ImportDirective node) {
    final imports = {
      'package:riverpod/all.dart': 'package:riverpod/riverpod.dart',
      'package:flutter_riverpod/all.dart':
          'package:flutter_riverpod/flutter_riverpod.dart',
      'package:hooks_riverpod/all.dart':
          'package:hooks_riverpod/hooks_riverpod.dart'
    };
    for (final entry in imports.entries) {
      if (entry.key == node.uri.stringValue) {
        yieldPatch(entry.value, node.uri.offset + 1, node.uri.end - 1);
      }
    }
  }
}
