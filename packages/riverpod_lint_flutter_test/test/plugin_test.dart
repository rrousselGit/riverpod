import 'dart:io';

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:analysis_server_plugin/src/correction/fix_generators.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:path/path.dart' as p;
import 'package:cli_util/cli_logging.dart';
import 'package:riverpod_lint/main.dart';
import 'package:test/test.dart';

import 'io_utils.dart';

final _logger = Logger.standard();

Future<R> progress<R>(String message, Future<R> Function() body) async {
  final progress = _logger.progress(message);
  try {
    return await body();
  } finally {
    progress.finish(showTiming: true);
  }
}

Future<void> main() async {
  final registry = _PluginRegistry();
  plugin.register(registry);

  final filesToAnalyze = await progress(
    'Finding files to analyze',
    () async => await _findFilesToAnalyze().toList(),
  );

  for (final file in filesToAnalyze) {
    group(p.basenameWithoutExtension(file.path), () {
      late final ResolvedUnitResult unit;
      late final ResolvedLibraryResult library;
      late final Iterable<SourceRange> uniqueRanges;

      setUpAll(() async {
        final unitResult = await resolveFile2(path: file.path);
        unitResult as ResolvedUnitResult;
        unit = unitResult;
        final session = unitResult.session;

        final libraryResult = await session.getResolvedLibrary(file.path);
        libraryResult as ResolvedLibraryResult;

        library = libraryResult;

        final visitor = _VisitAllNodes((node) => range.node(node));

        unit.unit.accept(visitor);
        final astRanges = visitor._result;

        final tokensRanges = <SourceRange>[];
        for (
          Token? token = unit.unit.beginToken;
          token != null && token != unit.unit.endToken;
          token = token.next
        ) {
          tokensRanges.add(range.token(token));
        }

        uniqueRanges = astRanges.followedBy(tokensRanges).toSet();
      });

      _testProducers(
        registry.assists,
        () => (unit: unit, library: library, uniqueRanges: uniqueRanges),
        file,
        groupName: 'assist',
        id: (producer) => producer.assistKind!.id,
      );
      _testProducers(
        registry.fixes.map((e) => e.generator),
        () => (unit: unit, library: library, uniqueRanges: uniqueRanges),
        file,
        groupName: 'fix',
        id: (producer) => producer.fixKind!.id,
      );
    });
  }
}

void _testProducers(
  Iterable<ProducerGenerator> producerFactories,
  ({
    ResolvedUnitResult unit,
    ResolvedLibraryResult library,
    Iterable<SourceRange> uniqueRanges,
  })
  Function()
  results,
  File file, {
  required String groupName,
  required String Function(CorrectionProducer<ParsedUnitResult> producer) id,
}) {
  group(groupName, () {
    for (final producerFactory in producerFactories) {
      final stubProducer = producerFactory(
        context: StubCorrectionProducerContext.instance,
      );
      final producerId = id(stubProducer);

      test(producerId, () async {
        final uniqueSourceOutputs = <String, List<({int offset, String id})>>{};
        final (:unit, :library, :uniqueRanges) = results();

        for (final offset in uniqueRanges.map((e) => e.offset)) {
          final changeBuilder = ChangeBuilder(session: unit.session);
          final context = CorrectionProducerContext.createResolved(
            libraryResult: library,
            unitResult: unit,
            selectionOffset: offset,
          );
          final producer = producerFactory(context: context);
          await producer.compute(changeBuilder);

          if (changeBuilder.sourceChange.edits.isEmpty) continue;

          final editedSources = changeBuilder.sourceChange.edits.map(
            (e) => SourceEdit.applySequence(unit.content, e.edits),
          );

          for (final editedSource in editedSources) {
            final offsets = uniqueSourceOutputs[editedSource] ??= [];
            offsets.add((offset: offset, id: producerId));
          }
        }

        await _writeAssistResultToFile(
          uniqueSourceOutputs,
          file,
          producerId: producerId,
          groupName: groupName,
        );
      });
    }
  });
}

Future<void> _writeAssistResultToFile(
  Map<String, List<({String id, int offset})>> uniqueSourceOutputs,
  File file, {
  required String producerId,
  required String groupName,
}) async {
  await Future.wait([
    for (final (index, entry) in uniqueSourceOutputs.entries.indexed)
      Future(() async {
        final baseName = p.basenameWithoutExtension(file.path);
        final outputFile = file.parent
            .dir(baseName)
            .dir(producerId)
            .file('$baseName$index.$groupName.dart');
        await outputFile.create(recursive: true);

        final offsetsForKind = <String, List<int>>{};
        for (final (:id, :offset) in entry.value) {
          final offsets = offsetsForKind[id] ??= [];
          offsets.add(offset);
        }

        final header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ${offsetsForKind.entries.map((e) => '[${e.key}?offset=${e.value.join(',')}]').join(' ')}
''';

        var content = entry.key;
        content = content.replaceAll(
          '$baseName',
          '$baseName${index}.$groupName',
        );

        await outputFile.writeAsString('$header\n$content');
      }),
  ]);
}

Stream<File> _findFilesToAnalyze() {
  return Directory.current
      .list(recursive: true)
      .where((e) => e is File)
      .cast<File>()
      .where(
        (e) =>
            e.path.endsWith('.dart') &&
            !e.path.endsWith('.g.dart') &&
            !e.path.contains('.assist') &&
            !e.path.contains('.fix') &&
            !e.path.contains('.rule'),
      );
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
