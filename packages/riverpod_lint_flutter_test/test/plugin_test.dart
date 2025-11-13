import 'dart:io';

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:analysis_server_plugin/src/correction/fix_generators.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_workspace.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_lint/main.dart';

import 'io_utils.dart';

Future<void> main() async {
  final registry = _PluginRegistry();
  plugin.register(registry);

  final filesToAnalyze = <File>[
    File(
      '/Users/ext-remi.rousselet/dev/rrousselGit/riverpod/packages/riverpod_lint_flutter_test/test/assists/convert_class_based_provider_to_functional/convert_class_based_provider_to_functional.dart',
    ),
  ];

  for (final file in filesToAnalyze) {
    final result = await resolveFile2(path: file.path);
    result as ResolvedUnitResult;
    final session = result.session;

    final source = result.content;

    final libraryResult = await session.getResolvedLibrary(file.path);
    libraryResult as ResolvedLibraryResult;

    final uniqueSourceOutputs =
        <String, List<({int offset, AssistKind kind})>>{};

    for (final assist in registry.assists) {
      final visitor = _VisitAllNodes((node) => range.node(node));

      result.unit.accept(visitor);
      final astRanges = visitor._result;

      final tokensRanges = <SourceRange>[];
      for (
        Token? token = result.unit.beginToken;
        token != null && token != result.unit.endToken;
        token = token.next
      ) {
        tokensRanges.add(range.token(token));
      }

      final uniqueOffsets =
          astRanges.followedBy(tokensRanges).map((e) => e.offset).toSet();

      for (final offset in uniqueOffsets) {
        final changeBuilder = ChangeBuilder(session: session);
        final context = CorrectionProducerContext.createResolved(
          libraryResult: libraryResult,
          unitResult: result,
          selectionOffset: offset,
        );
        final producer = assist(context: context);

        await producer.compute(changeBuilder);

        final assistKind = producer.assistKind;
        if (assistKind == null) {
          throw AssertionError('Assist kind is null');
        }

        if (changeBuilder.sourceChange.edits.isEmpty) continue;

        final editedSources = changeBuilder.sourceChange.edits.map(
          (e) => SourceEdit.applySequence(source, e.edits),
        );

        for (final editedSource in editedSources) {
          final offsets = uniqueSourceOutputs[editedSource] ??= [];
          offsets.add((offset: offset, kind: assistKind));
        }
      }
    }

    for (final (index, entry) in uniqueSourceOutputs.entries.indexed) {
      final baseName = p.basenameWithoutExtension(file.path);
      final outputFile = file.parent.dir(baseName).file('assist${index}.dart');
      outputFile.createSync(recursive: true);

      final offsetsForKind = <String, List<int>>{};
      for (final (:kind, :offset) in entry.value) {
        final offsets = offsetsForKind[kind.id] ??= [];
        offsets.add(offset);
      }

      final header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ${offsetsForKind.entries.map((e) => '[${e.key}?offset=${e.value.join(',')}]').join(' ')}
''';

      var content = entry.key;
      content = content.replaceAll('$baseName', 'assist${index}');

      outputFile.writeAsStringSync('$header\n$content');
    }
  }
}

class _VisitAllNodes<T> extends GeneralizingAstVisitor<void> {
  _VisitAllNodes(this.cb);
  final T Function(AstNode node) cb;

  final _result = <T>[];

  @override
  void visitNode(AstNode node) {
    _result.add(cb(node));
    super.visitNode(node);
  }
}

class _PluginRegistry extends PluginRegistry {
  final List<ProducerGenerator> assists = [];
  final List<({LintCode code, ProducerGenerator generator})> fixes = [];
  final List<AbstractAnalysisRule> lintRules = [];
  final List<AbstractAnalysisRule> warningRules = [];

  @override
  void registerAssist(ProducerGenerator generator) {
    assists.add(generator);
  }

  @override
  void registerFixForRule(LintCode code, ProducerGenerator generator) {
    fixes.add((code: code, generator: generator));
  }

  @override
  void registerLintRule(AbstractAnalysisRule rule) {
    lintRules.add(rule);
  }

  @override
  void registerWarningRule(AbstractAnalysisRule rule) {
    warningRules.add(rule);
  }
}
