import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:async/async.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_generator/src/riverpod_generator.dart';
import 'package:test/test.dart';

import '../../project_utils.dart';
import 'src/entrypoint.dart';

final hotReloadDir = Directory.current.dir('test/integration/hot_reload');
final srcDir = hotReloadDir.dir('src');

class HotReloadRunner {
  HotReloadRunner._(this._workspace);

  static Future<HotReloadRunner> start(
    String content,
  ) async {
    final runner = HotReloadRunner._(srcDir);
    addTearDown(runner.close);

    runner._writeMain();

    await runner.updateRenders(content);

    runner._process = Process.start(
      'dart',
      [
        '--enable-vm-service',
        // Enable asserts to make sure reassemble goes through
        '--enable-asserts',
        // Flag the code as running in debug mode according to Flutter's convention
        // TODO: refactor to use a constant "isAssertEnabled" if that is added:
        // https://github.com/dart-lang/language/issues/2876
        '--define=dart.vm.product=true',
        srcDir.file('main.dart').path,
      ],
      // No workingDirection as hotReloader expects to be run from the root
      // of the project.
    );

    await runner._listenToOutput();

    return runner;
  }

  final Directory _workspace;
  Future<Process>? _process;

  final _onClose = <Future<void> Function()>[];

  final _renderController = StreamController<String>();
  late final currentRender = StreamQueue<String>(_renderController.stream);

  void _writeMain() {
    writeFile(
      _workspace.file('main.dart'),
      '''
import 'entrypoint.dart';
import 'renderer.dart';

void main() {
  entrypoint(renderer);
}
''',
    );
  }

  int _testNumber = 0;

  Future<void> updateRenders(String source) async {
    final sourceWithImports = '''
library renderer;
// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'renderer.g.dart';

$source
''';

    final testId = _testNumber++;

    // Giving a unique name to the package to avoid the analyzer cache
    // messing up tests.
    final packageName = 'test_lib$testId';

    final analysisResult = await resolveSources(
      {'$packageName|lib/renderer.dart': sourceWithImports},
      (resolver) {
        return resolver.resolveRiverpodLibraryResult(
          ignoreErrors: true,
        );
      },
    );

    final generated = RiverpodGenerator(const {}).runGenerator(analysisResult);

    writeFile(_workspace.file('renderer.dart'), sourceWithImports);
    writeFile(_workspace.file('renderer.g.dart'), '''
part of 'renderer.dart';
$generated
''');
  }

  Future<void> _listenToOutput() {
    StringBuffer? _pendingRenderBuffer;

    return _process!.then((process) {
      // Folds <rendering>{...}</done rendering> in a single String event.
      // Any stdout event outside of those tags is ignored.
      // Errors are forwarded as-is.

      final outSub = process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .map((e) => e.startsWith('flutter: ') ? e.substring(9) : e)
          .listen((line) {
        if (line.contains(renderStart)) {
          _pendingRenderBuffer = StringBuffer();
        } else if (line.contains(renderEnd)) {
          final render = _pendingRenderBuffer!.toString();
          _pendingRenderBuffer = null;
          _renderController.add(render);
        } else {
          if (_pendingRenderBuffer?.isEmpty ?? false) {
            _pendingRenderBuffer?.write(line);
          } else {
            _pendingRenderBuffer?.write('\n$line');
          }
        }
      });
      _onClose.add(outSub.cancel);

      void onError(Object event) {
        _renderController.addError(event);
      }

      final errSub = process.stderr.transform(utf8.decoder).listen(onError);
      _onClose.add(errSub.cancel);
    });
  }

  Future<void> close() async {
    try {
      await Future.wait(_onClose.map((it) => it()));

      await _process?.then((process) => process.kill());
    } finally {
      unawaited(currentRender.cancel());
      await _renderController.close();
      // workspace dir is deleted by the test framework
    }
  }
}

extension ResolverX on Resolver {
  Future<RiverpodAnalysisResult> resolveRiverpodAnalyssiResult({
    String libraryName = 'renderer',
    bool ignoreErrors = false,
  }) async {
    final riverpodAst = await resolveRiverpodLibraryResult(
      libraryName: libraryName,
      ignoreErrors: ignoreErrors,
    );

    final result = RiverpodAnalysisResult();
    riverpodAst.accept(result);

    if (!ignoreErrors) {
      final errors = result.resolvedRiverpodLibraryResults
          .expand((e) => e.errors)
          .toList();
      if (errors.isNotEmpty) {
        throw StateError(errors.map((e) => '- $e\n').join());
      }
    }

    return result;
  }

  Future<ResolvedRiverpodLibraryResult> resolveRiverpodLibraryResult({
    String libraryName = 'renderer',
    bool ignoreErrors = false,
  }) async {
    final library = await _requireFindLibraryByName(
      libraryName,
      ignoreErrors: ignoreErrors,
    );
    final libraryAst =
        await library.session.getResolvedLibraryByElement(library);
    libraryAst as ResolvedLibraryResult;

    final result = ResolvedRiverpodLibraryResult.from(
      libraryAst.units.map((e) => e.unit).toList(),
    );

    return result;
  }

  Future<LibraryElement> _requireFindLibraryByName(
    String libraryName, {
    required bool ignoreErrors,
  }) async {
    final library = await findLibraryByName(libraryName);
    if (library == null) {
      throw StateError('No library found for name "$libraryName"');
    }

    if (!ignoreErrors) {
      final errorResult =
          await library.session.getErrors('/test_lib/lib/foo.dart');
      errorResult as ErrorsResult;

      final errors = errorResult.errors
          // Infos are only recommendations. There's no reason to fail just for this
          .where((e) => e.severity != Severity.info)
          .toList();

      if (errors.isNotEmpty) {
        throw StateError('''
The parsed library has errors:
${errors.map((e) => '- $e\n').join()}
''');
      }
    }

    return library;
  }
}

class RiverpodAnalysisResult extends RecursiveRiverpodAstVisitor {
  final providerContainerInstanceCreationExpressions =
      <ProviderContainerInstanceCreationExpression>[];
  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    super.visitProviderContainerInstanceCreationExpression(expression);
    providerContainerInstanceCreationExpressions.add(expression);
  }

  final providerScopeInstanceCreationExpressions =
      <ProviderScopeInstanceCreationExpression>[];
  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    super.visitProviderScopeInstanceCreationExpression(expression);
    providerScopeInstanceCreationExpressions.add(expression);
  }

  final consumerStateDeclarations = <ConsumerStateDeclaration>[];
  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {
    super.visitConsumerStateDeclaration(declaration);
    consumerStateDeclarations.add(declaration);
  }

  final consumerWidgetDeclarations = <ConsumerWidgetDeclaration>[];
  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {
    super.visitConsumerWidgetDeclaration(declaration);
    consumerWidgetDeclarations.add(declaration);
  }

  final hookConsumerWidgetDeclaration = <HookConsumerWidgetDeclaration>[];
  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {
    super.visitHookConsumerWidgetDeclaration(declaration);
    hookConsumerWidgetDeclaration.add(declaration);
  }

  final statefulHookConsumerWidgetDeclaration =
      <StatefulHookConsumerWidgetDeclaration>[];
  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {
    super.visitStatefulHookConsumerWidgetDeclaration(declaration);
    statefulHookConsumerWidgetDeclaration.add(declaration);
  }

  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];
  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration declaration) {
    super.visitLegacyProviderDeclaration(declaration);
    legacyProviderDeclarations.add(declaration);
  }

  final legacyProviderDependenciess = <LegacyProviderDependencies>[];
  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  ) {
    super.visitLegacyProviderDependencies(dependencies);
    legacyProviderDependenciess.add(dependencies);
  }

  final legacyProviderDependencys = <LegacyProviderDependency>[];
  @override
  void visitLegacyProviderDependency(LegacyProviderDependency dependency) {
    super.visitLegacyProviderDependency(dependency);
    legacyProviderDependencys.add(dependency);
  }

  final providerListenableExpressions = <ProviderListenableExpression>[];
  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression expression,
  ) {
    super.visitProviderListenableExpression(expression);
    providerListenableExpressions.add(expression);
  }

  final refInvocations = <RefInvocation>[];
  final refListenInvocations = <RefListenInvocation>[];
  @override
  void visitRefListenInvocation(RefListenInvocation invocation) {
    super.visitRefListenInvocation(invocation);
    refInvocations.add(invocation);
    refListenInvocations.add(invocation);
  }

  final refReadInvocations = <RefReadInvocation>[];
  @override
  void visitRefReadInvocation(RefReadInvocation invocation) {
    super.visitRefReadInvocation(invocation);
    refInvocations.add(invocation);
    refReadInvocations.add(invocation);
  }

  final refWatchInvocations = <RefWatchInvocation>[];
  @override
  void visitRefWatchInvocation(RefWatchInvocation invocation) {
    super.visitRefWatchInvocation(invocation);
    refInvocations.add(invocation);
    refWatchInvocations.add(invocation);
  }

  final resolvedRiverpodLibraryResults = <ResolvedRiverpodLibraryResult>[];
  @override
  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result) {
    super.visitResolvedRiverpodUnit(result);
    resolvedRiverpodLibraryResults.add(result);
  }

  final riverpodAnnotations = <RiverpodAnnotation>[];
  @override
  void visitRiverpodAnnotation(RiverpodAnnotation annotation) {
    super.visitRiverpodAnnotation(annotation);
    riverpodAnnotations.add(annotation);
  }

  final riverpodAnnotationDependencys = <RiverpodAnnotationDependency>[];
  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  ) {
    super.visitRiverpodAnnotationDependency(dependency);
    riverpodAnnotationDependencys.add(dependency);
  }

  final riverpodAnnotationDependencies = <RiverpodAnnotationDependencies>[];
  @override
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies dependencies,
  ) {
    super.visitRiverpodAnnotationDependencies(dependencies);
    riverpodAnnotationDependencies.add(dependencies);
  }

  final consumerStatefulWidgetDeclarations =
      <ConsumerStatefulWidgetDeclaration>[];
  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {
    super.visitConsumerStatefulWidgetDeclaration(declaration);
    consumerStatefulWidgetDeclarations.add(declaration);
  }

  final generatorProviderDeclarations = <GeneratorProviderDeclaration>[];
  final statefulProviderDeclarations = <StatefulProviderDeclaration>[];
  @override
  void visitStatefulProviderDeclaration(
    StatefulProviderDeclaration declaration,
  ) {
    super.visitStatefulProviderDeclaration(declaration);
    generatorProviderDeclarations.add(declaration);
    statefulProviderDeclarations.add(declaration);
  }

  final statelessProviderDeclarations = <StatelessProviderDeclaration>[];
  @override
  void visitStatelessProviderDeclaration(
    StatelessProviderDeclaration declaration,
  ) {
    super.visitStatelessProviderDeclaration(declaration);
    generatorProviderDeclarations.add(declaration);
    statelessProviderDeclarations.add(declaration);
  }

  final widgetRefInvocations = <WidgetRefInvocation>[];
  final widgetRefListenInvocations = <WidgetRefListenInvocation>[];
  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation invocation) {
    super.visitWidgetRefListenInvocation(invocation);
    widgetRefInvocations.add(invocation);
    widgetRefListenInvocations.add(invocation);
  }

  final widgetRefListenManualInvocations = <WidgetRefListenManualInvocation>[];
  @override
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation invocation,
  ) {
    super.visitWidgetRefListenManualInvocation(invocation);
    widgetRefInvocations.add(invocation);
    widgetRefListenManualInvocations.add(invocation);
  }

  final widgetRefReadInvocations = <WidgetRefReadInvocation>[];
  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation invocation) {
    super.visitWidgetRefReadInvocation(invocation);
    widgetRefInvocations.add(invocation);
    widgetRefReadInvocations.add(invocation);
  }

  final widgetRefWatchInvocations = <WidgetRefWatchInvocation>[];
  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation invocation) {
    super.visitWidgetRefWatchInvocation(invocation);
    widgetRefInvocations.add(invocation);
    widgetRefWatchInvocations.add(invocation);
  }
}

extension TakeList<T extends ProviderDeclaration> on List<T> {
  Map<String, T> takeAll(List<String> names) {
    final result = Map.fromEntries(map((e) => MapEntry(e.name.lexeme, e)));
    return result.take(names);
  }

  T findByName(String name) {
    return singleWhere((element) => element.name.lexeme == name);
  }
}

extension LibraryElementX on LibraryElement {
  Element findElementWithName(String name) {
    return topLevelElements.singleWhere(
      (element) => !element.isSynthetic && element.name == name,
      orElse: () => throw StateError('No element found with name "$name"'),
    );
  }
}

extension MapTake<Key, Value> on Map<Key, Value> {
  Map<Key, Value> take(List<Key> keys) {
    return <Key, Value>{
      for (final key in keys)
        if (!containsKey(key))
          key: throw StateError('No key $key found')
        else
          key: this[key] as Value,
    };
  }
}
