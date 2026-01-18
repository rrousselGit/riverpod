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
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/line_info.dart';
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

import 'encoders.dart';
import 'io_utils.dart';
import 'registry.dart';
import 'context.dart';
import 'string.dart';

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
      late final Set<String> testIds;

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

        testIds = _findTestIds(unit);
        _verifyAllIdsExist(registry, testIds);
      });

      _testProducers(
        registry.assists,
        () => (
          unit: unit,
          library: library,
          uniqueOffsets: uniqueOffsets,
          testIds: testIds,
        ),
        file,
        groupName: 'assist',
        id: (producer) => producer.assistKind!.id,
      );

      _testFixes(
        registry,
        () => (
          unit: unit,
          library: library,
          uniqueOffsets: uniqueOffsets,
          testIds: testIds,
        ),
        file,
        id: (producer) => producer.fixKind!.id,
      );
    });
  }
}

void _testFixes(
  _PluginRegistry pluginRegistry,
  ({
    ResolvedLibraryResult library,
    Set<String> testIds,
    Iterable<int> uniqueOffsets,
    ResolvedUnitResult unit,
  })
  Function()
  result,
  File file, {
  required Function(CorrectionProducer<ParsedUnitResult> producer) id,
}) {
  for (final fix in pluginRegistry.fixes) {
    _testProducers(
      [fix.generator],
      () {
        final (
          :unit,
          :library,
          :uniqueOffsets,
          :testIds,
        ) = result();

        final rules =
            pluginRegistry.rules
                .where(
                  (e) => e.$1.diagnosticCodes.contains(fix.code),
                )
                .single;

        final diagnostics = _runRules(
          unit: unit,
          library: library,
          rules: [rules.$1],
        );

        final offsetsOverlappingDiagnostics = uniqueOffsets.where(
          (offset) => diagnostics.any(
            (e) => range.startOffsetLength(e.offset, e.length).contains(offset),
          ),
        );

        return (
          unit: unit,
          library: library,
          uniqueOffsets: offsetsOverlappingDiagnostics,
          testIds: testIds,
        );
      },
      file,
      groupName: 'fix',
      id: (producer) => producer.fixKind!.id,
    );
  }
}

void _verifyAllIdsExist(_PluginRegistry plugin, Set<String> testIds) {
  final actualIds = plugin.allIds().toSet();

  expect(
    actualIds,
    containsAll(testIds),
    reason: '''
class TestFor {
  const TestFor(this.id);
  ${actualIds.map((e) => "static const $e = TestFor('$e');").join('\n')}

  final String id;
}
''',
  );
}

List<Diagnostic> _runRules({
  required ResolvedUnitResult unit,
  required ResolvedLibraryResult library,
  required Iterable<AbstractAnalysisRule> rules,
}) {
  final _errorReporter = errorReporter;
  errorReporter = (_) {};

  try {
    final diagnosticsListener = RecordingDiagnosticListener();

    final registry = Registry();
    final context = Context.fromResolvedUnitResult(
      unit,
      library,
      diagnosticsListener,
    );

    for (final rule in rules) {
      rule.reporter = DiagnosticReporter(
        diagnosticsListener,
        unit.libraryFragment.source,
      );

      rule.registerNodeProcessors(registry, context);
    }

    unit.unit.accept(_InvokeVisitor(registry));

    return diagnosticsListener.diagnostics;
  } finally {
    errorReporter = _errorReporter;
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
    Set<String> testIds,
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
      final (:unit, :library, :uniqueOffsets, :testIds) = results();
      if (!testIds.contains(producerId)) return;

      final uniqueSourceOutputs =
          <({String header, String editedSource}), List<({int offset})>>{};
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

        final edit = changeBuilder.sourceChange.edits.single;

        final editedSource = SourceEdit.applySequence(
          unit.content,
          edit.edits,
        );
        final editedLineInfo = LineInfo.fromContent(editedSource);

        final header = encodePrioritizedSourceChanges(
          unmodifiedSource: unit.content,
          editedSource: editedSource,
          unmodifiedLineInfo: unit.lineInfo,
          editedLineInfo: editedLineInfo,
        );

        final offsetsForEdit =
            uniqueSourceOutputs[(
                  header: header,
                  editedSource: editedSource,
                )] ??=
                [];
        offsetsForEdit.add((offset: offset));
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
  File goldenFile({
    required String id,
    required String groupName,
    required int index,
  }) {
    final baseName = p.basenameWithoutExtension(path);

    return parent.file(
      '$baseName.$id-$index.$groupName.dart',
    );
  }

  String get _goldensPattern => '${p.basenameWithoutExtension(path)}.';

  Iterable<File> goldensForFile({
    required String id,
  }) {
    return parent
        .listSync()
        .whereType<File>()
        .where(
          (e) =>
              !e.path.endsWith('.g.dart') && !e.path.endsWith('.freezed.dart'),
        )
        .where(
          (e) {
            final fileName = p.basenameWithoutExtension(e.path);

            if (!fileName.startsWith(_goldensPattern) || e == this)
              return false;

            final [_, idAndIndex, _] = fileName.split('.');
            final [fileId, index] = idAndIndex.split('-');

            return fileId == id;
          },
        );
  }
}

Set<String> _findTestIds(ResolvedUnitResult unit) {
  final library =
      unit.unit.directives.whereType<LibraryDirective>().firstOrNull;
  final testIds = <String>{};

  for (final meta in library?.metadata ?? <Annotation>[]) {
    final annotation = meta.elementAnnotation?.computeConstantValue();
    if (annotation == null) continue;

    if (annotation.type?.element?.name != 'TestFor') continue;

    final id = annotation.getField('id')!.toStringValue();
    if (id == null) continue;

    testIds.add(id);
  }

  if (testIds.isEmpty) {
    throw StateError('No test ids found in ${unit.libraryElement.uri}');
  }

  return testIds;
}

final _goldenWrite = bool.parse(Platform.environment['goldens'] ?? 'false');

Future<void> _expectGoldensMatchProducers(
  Map<({String header, String editedSource}), List<({int offset})>>
  uniqueSourceOutputs,
  File file, {
  required String producerId,
  required String groupName,
}) async {
  if (_goldenWrite) {
    await _writeProducerResultToFile(
      uniqueSourceOutputs,
      sourceFile: file,
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
  Map<({String header, String editedSource}), List<({int offset})>>
  uniqueSourceOutputs,
  File file, {
  required String producerId,
  required String groupName,
}) async {
  final goldens =
      file.goldensForFile(id: producerId).map((e) => e.path).toSet();
  final mismatch = <({String? expected, String actual})>[];
  final missing = <({String filePath})>[];

  final actualFiles =
      uniqueSourceOutputs.entries.indexed.map(
        (e) {
          final goldenFile = file.goldenFile(
            id: producerId,
            index: e.$1,
            groupName: groupName,
          );
          final entry = e.$2;

          return (
            goldenFile,
            _encodeProducerOutput(
              sourceFile: file,
              source: entry.key,
              goldenFile: goldenFile,
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
        missing.map((e) => 'Missing golden: ${e.filePath}\n'),
      );
    }

    if (mismatch.isNotEmpty) {
      buffer.writeAll(
        mismatch.map((e) => 'Mismatch: ${e.actual}\n'),
      );
    }

    throw TestFailure(buffer.toString());
  }
}

String _encodeProducerOutput({
  required File sourceFile,
  required File goldenFile,
  required ({String header, String editedSource}) source,
  required String producerId,
  required Iterable<int> offsets,
}) {
  final offsetsForKind = <String, List<int>>{};
  for (final offset in offsets) {
    final offsets = offsetsForKind[producerId] ??= [];
    offsets.add(offset);
  }

  final buffer = StringBuffer('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// ${offsetsForKind.entries.map((e) => '[${e.key}?offset=${e.value.join(',')}]').join(' ')}
''');

  if (source.header.isNotEmpty) {
    buffer.write(source.header.indentWith('// '));
  }

  var content = source.editedSource;
  content = content.replaceAll(
    "part '${p.basenameWithoutExtension(sourceFile.path)}",
    "part '${p.basenameWithoutExtension(goldenFile.path)}",
  );

  buffer.write(content);

  // Format the content using dart_style
  try {
    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(buffer.toString());
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
    return buffer.toString();
  }
}

Future<void> _writeProducerResultToFile(
  Map<({String header, String editedSource}), List<({int offset})>>
  uniqueSourceOutputs, {
  required File sourceFile,
  required String producerId,
  required String groupName,
}) async {
  final goldens = sourceFile.goldensForFile(id: producerId);

  try {
    await Future.wait(
      goldens.map((e) => e.delete()),
    );
  } on PathNotFoundException {
    // Silence not-found errors
  }

  await Future.wait([
    for (final (index, entry) in uniqueSourceOutputs.entries.indexed)
      Future(() async {
        final outputFile = sourceFile.goldenFile(
          id: producerId,
          groupName: groupName,
          index: index,
        );

        await outputFile.create(recursive: true);

        await outputFile.writeAsString(
          _encodeProducerOutput(
            sourceFile: sourceFile,
            source: entry.key,
            goldenFile: outputFile,
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
        (e) {
          switch (e.uri.pathSegments
              .skipWhile((e) => e != 'riverpod_lint_flutter_test')
              .skip(1)
              .toList()) {
            case ['test', _, _, ...]:
              return true;

            case _:
              return false;
          }
        },
      )
      .where(
        (e) {
          return e.path.endsWith('.dart') &&
              !e.path.endsWith('.g.dart') &&
              !e.path.endsWith('.freezed.dart') &&
              !e.path.contains('.assist') &&
              !e.path.contains('.fix') &&
              !e.path.contains('.rule');
        },
      );
}

class _VisitAllNodes<AccumulatedT> extends GeneralizingAstVisitor<void> {
  _VisitAllNodes(this.cb);
  final AccumulatedT Function(AstNode node) cb;

  final _result = <AccumulatedT>[];

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

  Iterable<ProducerGenerator> get producers => assists.followedBy(
    fixes.map((e) => e.generator),
  );

  Iterable<String> allIds() {
    final assistIds = assists
        .map((e) => e(context: StubCorrectionProducerContext.instance))
        .map((e) => e.assistKind!.id);
    final fixIds = fixes
        .map(
          (e) => e.generator(context: StubCorrectionProducerContext.instance),
        )
        .map((e) => e.fixKind!.id);
    final ruleIds = rules.map((e) => e.$1.name);

    return assistIds.followedBy(fixIds).followedBy(ruleIds);
  }

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
