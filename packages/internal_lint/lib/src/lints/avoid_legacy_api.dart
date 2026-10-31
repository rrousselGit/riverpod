import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:meta/meta.dart';

import '../legacy_api.dart';

/// Forbids the legacy APIs outside of the files that
/// `baselines/legacy_api.yaml` allows.
@internal
class AvoidLegacyApi extends AnalysisRule {
  AvoidLegacyApi()
    : super(
        name: 'avoid_legacy_api',
        description:
            'Only use legacy APIs in the files that '
            '$legacyApiPolicyPath allows.',
      );

  static const code = LintCode(
    'avoid_legacy_api',
    '{0}',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final policy = _PolicyCache.find(context.definingUnit.file);
    if (policy == null) return;

    final visitor = _Visitor(this, policy);
    registry.addCompilationUnit(this, visitor);
  }
}

/// The policy of a repository, and the path of its root.
typedef _RootedPolicy = ({String root, LegacyApiPolicy policy});

abstract final class _PolicyCache {
  static final _byRoot = <String, _RootedPolicy?>{};

  /// The policy of the repository containing [file], if any.
  ///
  /// Read once per repository: changes need an analyzer restart.
  static _RootedPolicy? find(File file) {
    for (var folder = file.parent; ; folder = folder.parent) {
      if (_byRoot.containsKey(folder.path)) return _byRoot[folder.path];

      final policyFile = folder.getChildAssumingFile(legacyApiPolicyPath);
      if (policyFile.exists) {
        return _byRoot[folder.path] = (
          root: folder.path,
          policy: LegacyApiPolicy.parse(policyFile.readAsStringSync()),
        );
      }

      if (folder.isRoot) return null;
    }
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.rooted);

  final AvoidLegacyApi rule;
  final _RootedPolicy rooted;

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final filePath = node.declaredFragment?.source.fullName;
    if (filePath == null) return;

    final path = relativePolicyPath(filePath, root: rooted.root);
    final policy = rooted.policy;
    if (policy.isIgnored(path) || policy.isAllowed(path)) return;

    final uses = <_LegacyUse>[];
    node.accept(_LegacyUseCollector(uses));

    if (policy.isBaseline(path)) {
      if (uses.isEmpty) {
        rule.reportAtOffset(
          0,
          0,
          arguments: [
            'This file no longer uses legacy APIs. '
                'Remove it from the baseline of $legacyApiPolicyPath.',
          ],
        );
      }
      return;
    }

    for (final use in uses) {
      rule.reportAtOffset(
        use.offset,
        use.length,
        arguments: [
          '${use.description} is a legacy API. Use Notifier/NotifierProvider '
              'instead. Legacy APIs are only allowed in the files that '
              '$legacyApiPolicyPath allows.',
        ],
      );
    }
  }
}

typedef _LegacyUse = ({int offset, int length, String description});

class _LegacyUseCollector extends RecursiveAstVisitor<void> {
  _LegacyUseCollector(this.uses);

  final List<_LegacyUse> uses;

  void _add(AstNode node, String description) {
    uses.add((
      offset: node.offset,
      length: node.length,
      description: description,
    ));
  }

  void _addElement(AstNode node, Element? element) {
    if (element == null || !isLegacyElement(element)) return;
    _add(node, '`${element.displayName}`');
  }

  @override
  void visitImportDirective(ImportDirective node) {
    final uri = node.libraryImport?.importedLibrary?.uri;
    if (uri != null && isLegacyLibrary(uri)) _add(node, '`$uri`');

    // The names of the combinators are reported where they are used.
  }

  @override
  void visitExportDirective(ExportDirective node) {
    final export = node.libraryExport;
    final library = export?.exportedLibrary;
    if (export == null || library == null) return;

    if (isLegacyLibrary(library.uri)) {
      _add(node, '`${library.uri}`');
      return;
    }

    final exported = library.exportNamespace.definedNames2.entries.where(
      (entry) => _isExported(entry.key, node.combinators),
    );
    final legacy = exported
        .map((entry) => entry.value)
        .where(isLegacyElement)
        .map((element) => '`${element.displayName}`')
        .toSet();

    if (legacy.isNotEmpty) _add(node, 'Exporting ${legacy.join(', ')}');

    // The names of the combinators are reported above, as part of the export.
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    _addElement(node, node.element);
    super.visitSimpleIdentifier(node);
  }

  // The identifiers that are assigned to have no element: it is on the
  // assignment, as the getter read and the setter written.
  void _addAssignment(
    Expression target,
    Element? readElement,
    Element? writeElement,
  ) {
    final name = switch (target) {
      PropertyAccess() => target.propertyName,
      PrefixedIdentifier() => target.identifier,
      _ => target,
    };
    _addElement(name, writeElement ?? readElement);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    _addAssignment(node.leftHandSide, node.readElement, node.writeElement);
    super.visitAssignmentExpression(node);
  }

  @override
  void visitPostfixExpression(PostfixExpression node) {
    _addAssignment(node.operand, node.readElement, node.writeElement);
    super.visitPostfixExpression(node);
  }

  @override
  void visitPrefixExpression(PrefixExpression node) {
    _addAssignment(node.operand, node.readElement, node.writeElement);
    super.visitPrefixExpression(node);
  }

  @override
  void visitNamedType(NamedType node) {
    _addElement(node, node.element);
    super.visitNamedType(node);
  }
}

/// Whether the [combinators] of an export let [name] through.
bool _isExported(String name, List<Combinator> combinators) {
  // Setters are exported along with their getter.
  final getterName = name.endsWith('=')
      ? name.substring(0, name.length - 1)
      : name;

  for (final combinator in combinators) {
    final names = switch (combinator) {
      ShowCombinator() => combinator.shownNames,
      HideCombinator() => combinator.hiddenNames,
    }.map((e) => e.name);

    final listed = names.contains(getterName);
    if (combinator is ShowCombinator && !listed) return false;
    if (combinator is HideCombinator && listed) return false;
  }
  return true;
}
