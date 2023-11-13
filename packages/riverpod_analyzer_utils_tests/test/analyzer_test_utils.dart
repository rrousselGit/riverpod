import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_generator/src/riverpod_generator.dart';
import 'package:test/test.dart';

int _testNumber = 0;

/// Due to [resolveSource] throwing if trying to interact with the resolver
/// after the future completed, we change the syntax to make sure our test
/// executes within the resolver scope.
@isTest
void testSource(
  String description,
  Future<void> Function(Resolver resolver) run, {
  required String source,
  Map<String, String> files = const {},
  bool runGenerator = false,
  Timeout? timeout,
}) {
  final testId = _testNumber++;
  test(
    description,
    timeout: timeout,
    () async {
      // Giving a unique name to the package to avoid the analyzer cache
      // messing up tests.
      final packageName = 'test_lib$testId';
      final sourceWithLibrary = 'library foo;$source';

      final enclosingZone = Zone.current;

      final otherSources = {
        for (final entry in files.entries)
          '$packageName|lib/${entry.key}':
              'library "${entry.key}"; ${entry.value}',
      };

      String? generated;
      if (runGenerator) {
        final analysisResult = await resolveSources(
          {
            '$packageName|lib/foo.dart': sourceWithLibrary,
            ...otherSources,
          },
          (resolver) {
            return resolver.resolveRiverpodLibraryResult(
              ignoreErrors: true,
            );
          },
        );
        generated = RiverpodGenerator(const {}).runGenerator(analysisResult);
      }

      await resolveSources({
        '$packageName|lib/foo.dart': sourceWithLibrary,
        if (generated != null)
          '$packageName|lib/foo.g.dart': 'part of "foo.dart";$generated',
        ...otherSources,
      }, (resolver) async {
        try {
          final originalZone = Zone.current;
          return runZoned(
            () => run(resolver),
            zoneSpecification: ZoneSpecification(
              // Somehow prints are captured inside the callback. Let's restore them
              print: (self, parent, zone, line) => enclosingZone.print(line),
              handleUncaughtError: (self, parent, zone, error, stackTrace) {
                originalZone.handleUncaughtError(error, stackTrace);
                enclosingZone.handleUncaughtError(error, stackTrace);
              },
            ),
          );
        } catch (err, stack) {
          enclosingZone.handleUncaughtError(err, stack);
        }
      });
    },
  );
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

extension ResolverX on Resolver {
  Future<RiverpodAnalysisResult> resolveRiverpodAnalysisResult({
    String libraryName = 'foo',
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
    String libraryName = 'foo',
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

    expectValidParentChildrenRelationship(result);

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

/// Visit all the nodes of the AST and ensure that that all children
/// have the correct parent.
void expectValidParentChildrenRelationship(
  ResolvedRiverpodLibraryResult result,
) {
  result.accept(_ParentRiverpodVisitor(null));
}

class _ParentRiverpodVisitor extends RecursiveRiverpodAstVisitor {
  _ParentRiverpodVisitor(this.expectedParent);

  final RiverpodAst? expectedParent;

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression declaration,
  ) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression declaration,
  ) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration declaration) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  ) {
    expect(
      dependencies.parent,
      expectedParent,
      reason:
          'Node ${dependencies.runtimeType} should have $expectedParent as parent',
    );
    dependencies.visitChildren(_ParentRiverpodVisitor(dependencies));
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency dependency) {
    expect(
      dependency.parent,
      expectedParent,
      reason:
          'Node ${dependency.runtimeType} should have $expectedParent as parent',
    );
    dependency.visitChildren(_ParentRiverpodVisitor(dependency));
  }

  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression expression,
  ) {
    expect(
      expression.parent,
      expectedParent,
      reason:
          'Node ${expression.runtimeType} should have $expectedParent as parent',
    );
    expression.visitChildren(_ParentRiverpodVisitor(expression));
  }

  @override
  void visitRefListenInvocation(RefListenInvocation invocation) {
    expect(
      invocation.parent,
      expectedParent,
      reason:
          'Node ${invocation.runtimeType} should have $expectedParent as parent',
    );
    invocation.visitChildren(_ParentRiverpodVisitor(invocation));
  }

  @override
  void visitRefReadInvocation(RefReadInvocation invocation) {
    expect(
      invocation.parent,
      expectedParent,
      reason:
          'Node ${invocation.runtimeType} should have $expectedParent as parent',
    );
    invocation.visitChildren(_ParentRiverpodVisitor(invocation));
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation invocation) {
    expect(
      invocation.parent,
      expectedParent,
      reason:
          'Node ${invocation.runtimeType} should have $expectedParent as parent',
    );
    invocation.visitChildren(_ParentRiverpodVisitor(invocation));
  }

  @override
  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result) {
    expect(
      result.parent,
      expectedParent,
      reason:
          'Node ${result.runtimeType} should have $expectedParent as parent',
    );
    result.visitChildren(_ParentRiverpodVisitor(result));
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation annotation) {
    expect(
      annotation.parent,
      expectedParent,
      reason:
          'Node ${annotation.runtimeType} should have $expectedParent as parent',
    );
    annotation.visitChildren(_ParentRiverpodVisitor(annotation));
  }

  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  ) {
    expect(
      dependency.parent,
      expectedParent,
      reason:
          'Node ${dependency.runtimeType} should have $expectedParent as parent',
    );
    dependency.visitChildren(_ParentRiverpodVisitor(dependency));
  }

  @override
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies dependencies,
  ) {
    expect(
      dependencies.parent,
      expectedParent,
      reason:
          'Node ${dependencies.runtimeType} should have $expectedParent as parent',
    );
    dependencies.visitChildren(_ParentRiverpodVisitor(dependencies));
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  ) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
  ) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation invocation) {
    expect(
      invocation.parent,
      expectedParent,
      reason:
          'Node ${invocation.runtimeType} should have $expectedParent as parent',
    );
    invocation.visitChildren(_ParentRiverpodVisitor(invocation));
  }

  @override
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation invocation,
  ) {
    expect(
      invocation.parent,
      expectedParent,
      reason:
          'Node ${invocation.runtimeType} should have $expectedParent as parent',
    );
    invocation.visitChildren(_ParentRiverpodVisitor(invocation));
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation invocation) {
    expect(
      invocation.parent,
      expectedParent,
      reason:
          'Node ${invocation.runtimeType} should have $expectedParent as parent',
    );
    invocation.visitChildren(_ParentRiverpodVisitor(invocation));
  }

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation invocation) {
    expect(
      invocation.parent,
      expectedParent,
      reason:
          'Node ${invocation.runtimeType} should have $expectedParent as parent',
    );
    invocation.visitChildren(_ParentRiverpodVisitor(invocation));
  }

  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {
    expect(
      declaration.parent,
      expectedParent,
      reason:
          'Node ${declaration.runtimeType} should have $expectedParent as parent',
    );
    declaration.visitChildren(_ParentRiverpodVisitor(declaration));
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

  final legacyProviderDependencies = <LegacyProviderDependencies>[];
  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  ) {
    super.visitLegacyProviderDependencies(dependencies);
    legacyProviderDependencies.add(dependencies);
  }

  final legacyProviderDependencyList = <LegacyProviderDependency>[];
  @override
  void visitLegacyProviderDependency(LegacyProviderDependency dependency) {
    super.visitLegacyProviderDependency(dependency);
    legacyProviderDependencyList.add(dependency);
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

  final riverpodAnnotationDependencyList = <RiverpodAnnotationDependency>[];
  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  ) {
    super.visitRiverpodAnnotationDependency(dependency);
    riverpodAnnotationDependencyList.add(dependency);
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
  final classBasedProviderDeclarations = <ClassBasedProviderDeclaration>[];
  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  ) {
    super.visitClassBasedProviderDeclaration(declaration);
    generatorProviderDeclarations.add(declaration);
    classBasedProviderDeclarations.add(declaration);
  }

  final functionalProviderDeclarations = <FunctionalProviderDeclaration>[];
  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
  ) {
    super.visitFunctionalProviderDeclaration(declaration);
    generatorProviderDeclarations.add(declaration);
    functionalProviderDeclarations.add(declaration);
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
