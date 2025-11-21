import 'dart:async';
import 'dart:io';

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:analysis_server_plugin/src/correction/fix_generators.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/src/dart/error/lint_codes.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_lint/main.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'io_utils.dart';
import 'registry.dart';
import 'context.dart';

Future<void> main() async {
  final registry = _PluginRegistry();
  plugin.register(registry);

  final filesToAnalyze = await _findFilesToAnalyze().toList();

  final collection = AnalysisContextCollection(
    includedPaths: filesToAnalyze.map((e) => e.absolute.path).toList(),
  );

  for (final file in filesToAnalyze) {
    group(p.basename(file.path), () {
      late final ResolvedUnitResult unit;
      late final ResolvedLibraryResult library;
      late final Iterable<int> uniqueOffsets;

      setUpAll(() async {
        final context = collection.contextFor(file.absolute.path);
        final session = context.currentSession;

        final unitResult = await session.getResolvedUnit(file.absolute.path);
        unitResult as ResolvedUnitResult;
        unit = unitResult;

        final libraryResult = await session.getResolvedLibrary(
          file.absolute.path,
        );
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

        uniqueOffsets =
            astRanges.followedBy(tokensRanges).map((e) => e.offset).toSet();
      });

      _testProducers(
        registry.assists,
        () => (unit: unit, library: library, uniqueOffsets: uniqueOffsets),
        file,
        groupName: 'assist',
        id: (producer) => producer.assistKind!.id,
      );
      _testProducers(
        registry.fixes.map((e) => e.generator),
        () => (unit: unit, library: library, uniqueOffsets: uniqueOffsets),
        file,
        groupName: 'fix',
        id: (producer) => producer.fixKind!.id,
      );

      _testRules(
        registry.rules,
        () => (unit: unit, library: library),
        file,
      );
    });
  }
}

void _testRules(
  Iterable<(AbstractAnalysisRule, RuleType)> rules,
  ({
    ResolvedUnitResult unit,
    ResolvedLibraryResult library,
  })
  Function()
  results,
  File file,
) {
  for (final (rule, _) in rules) {
    test('Rule ${rule.name}', () async {
      final (
        :unit,
        :library,
      ) = results();

      final diagosticsListener = RecordingDiagnosticListener();
      rule.reporter = DiagnosticReporter(
        diagosticsListener,
        unit.libraryFragment.source,
      );

      final registry = Registry();
      final context = Context.fromResolvedUnitResult(
        unit,
        library,
        diagosticsListener,
      );

      rule.registerNodeProcessors(registry, context);

      unit.unit.accept(_InvokeVisitor(registry));

      print(diagosticsListener.diagnostics);
    });
  }
}

class _InvokeVisitor extends GeneralizingAstVisitor<void> {
  final Registry registry;

  _InvokeVisitor(this.registry);

  @override
  void visitNode(AstNode node) {
    super.visitNode(node);

    for (final (_, visitor) in registry.visitors) {
      node.accept(visitor);
    }
  }
}

void _testProducers(
  Iterable<ProducerGenerator> producerFactories,
  ({
    ResolvedUnitResult unit,
    ResolvedLibraryResult library,
    Iterable<int> uniqueOffsets,
  })
  Function()
  results,
  File file, {
  required String groupName,
  required String Function(CorrectionProducer<ParsedUnitResult> producer) id,
}) {
  for (final producerFactory in producerFactories) {
    final stubProducer = producerFactory(
      context: StubCorrectionProducerContext.instance,
    );
    final producerId = id(stubProducer);

    test('$groupName $producerId', () async {
      final uniqueSourceOutputs = <String, List<({int offset})>>{};
      final (:unit, :library, :uniqueOffsets) = results();

      final _errorReporter = errorReporter;
      errorReporter = (_) {};
      addTearDown(() => errorReporter = _errorReporter);

      for (final offset in uniqueOffsets) {
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
          offsets.add((offset: offset));
        }
      }

      await _expectGoldensMatchProducers(
        uniqueSourceOutputs,
        file,
        producerId: producerId,
        groupName: groupName,
      );
    });
  }
}

extension on File {
  Directory goldensDir({
    required String id,
    required String groupName,
  }) {
    final baseName = p.basenameWithoutExtension(path);
    return parent.dir(baseName).dir(id);
  }
}

extension on Directory {
  File goldensFile({
    required int index,
    required String groupName,
  }) {
    final baseName = p.basenameWithoutExtension(path);

    return file(
      '$baseName$index.$groupName.dart',
    );
  }
}

final _goldenWrite = bool.parse(Platform.environment['goldens'] ?? 'false');

Future<void> _expectGoldensMatchProducers(
  Map<String, List<({int offset})>> uniqueSourceOutputs,
  File file, {
  required String producerId,
  required String groupName,
}) async {
  if (_goldenWrite) {
    await _writeProducerResultToFile(
      uniqueSourceOutputs,
      file,
      producerId: producerId,
      groupName: groupName,
    );
    return;
  }

  await _verifyGoldensMatchProducers(
    uniqueSourceOutputs,
    file,
    producerId: producerId,
    groupName: groupName,
  );
}

Future<void> _verifyGoldensMatchProducers(
  Map<String, List<({int offset})>> uniqueSourceOutputs,
  File file, {
  required String producerId,
  required String groupName,
}) async {
  final goldensDir = file.goldensDir(
    id: producerId,
    groupName: groupName,
  );

  final goldens =
      goldensDir
          .listSync(recursive: true)
          .whereType<File>()
          .map((e) => e.path)
          .toSet();
  final mismatch = <({String? expected, String actual})>[];
  final missing = <({String filePath})>[];

  final actualFiles =
      uniqueSourceOutputs.entries.indexed.map(
        (e) {
          final file = goldensDir.goldensFile(
            index: e.$1,
            groupName: groupName,
          );
          final entry = e.$2;

          return (
            file,
            _encodeProducerOutput(
              file: file,
              source: entry.key,
              index: e.$1,
              groupName: groupName,
              producerId: producerId,
              offsets: entry.value.map((e) => e.offset),
            ),
          );
        },
      ).toList();

  for (final (file, actual) in actualFiles) {
    try {
      final expected = file.readAsStringSync();

      if (actual != expected) {
        mismatch.add((expected: expected, actual: actual));
      }
    } on PathNotFoundException {
      mismatch.add((expected: null, actual: actual));
    }
  }

  for (final golden in goldens) {
    if (!actualFiles.any((e) => e.$1.path == golden)) {
      missing.add((filePath: golden));
    }
  }

  if (mismatch.isNotEmpty || missing.isNotEmpty) {
    final buffer = StringBuffer();

    if (missing.isNotEmpty) {
      buffer.writeAll(
        missing.map((e) => 'Missing golden: ${e.filePath}'),
        '\n',
      );
    }

    if (mismatch.isNotEmpty) {
      buffer.writeAll(
        mismatch.map((e) => 'Mismatch: ${e.actual}'),
        '\n',
      );
    }

    throw TestFailure(buffer.toString());
  }
}

String _encodeProducerOutput({
  required File file,
  required String source,
  required int index,
  required String groupName,
  required String producerId,
  required Iterable<int> offsets,
}) {
  final baseName = p.basenameWithoutExtension(file.path);

  final offsetsForKind = <String, List<int>>{};
  for (final offset in offsets) {
    final offsets = offsetsForKind[producerId] ??= [];
    offsets.add(offset);
  }

  final header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ${offsetsForKind.entries.map((e) => '[${e.key}?offset=${e.value.join(',')}]').join(' ')}
''';

  var content = source;
  content = content.replaceAll(
    '$baseName',
    '$baseName${index}.$groupName',
  );

  // Format the content using dart_style
  try {
    content = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(content);
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }

  return ('$header\n$content');
}

Future<void> _writeProducerResultToFile(
  Map<String, List<({int offset})>> uniqueSourceOutputs,
  File file, {
  required String producerId,
  required String groupName,
}) async {
  final goldensDir = file.goldensDir(
    id: producerId,
    groupName: groupName,
  );

  try {
    await goldensDir.delete(recursive: true);
  } on PathNotFoundException {
    // Silence not-found errors
  }

  await Future.wait([
    for (final (index, entry) in uniqueSourceOutputs.entries.indexed)
      Future(() async {
        final outputFile = goldensDir.goldensFile(
          index: index,
          groupName: groupName,
        );
        await outputFile.create(recursive: true);

        await outputFile.writeAsString(
          _encodeProducerOutput(
            file: file,
            source: entry.key,
            index: index,
            groupName: groupName,
            producerId: producerId,
            offsets: entry.value.map((e) => e.offset),
          ),
        );
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
            !e.path.endsWith('.freezed.dart') &&
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

enum RuleType { lint, warning }

class _PluginRegistry extends PluginRegistry {
  final List<ProducerGenerator> assists = [];
  final List<({LintCode code, ProducerGenerator generator})> fixes = [];
  final List<(AbstractAnalysisRule, RuleType)> rules = [];

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
    rules.add((rule, RuleType.lint));
  }

  @override
  void registerWarningRule(AbstractAnalysisRule rule) {
    rules.add((rule, RuleType.warning));
  }
}
