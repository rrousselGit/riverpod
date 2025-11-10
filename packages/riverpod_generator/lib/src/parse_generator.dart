import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

/// Forked from build_resolvers
String assetPath(AssetId assetId) {
  return p.posix.join('/${assetId.package}', assetId.path);
}

abstract class ParserGenerator<AnnotationT>
    extends GeneratorForAnnotation<AnnotationT> {
  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final allAnnotatedElements = <Element2>[];

    for (final annotated in library.annotatedWithExact(
      typeChecker,
      throwOnUnresolved: false,
    )) {
      allAnnotatedElements.add(annotated.element);
    }

    final uniqueCompilationUnits = <Uri, CompilationUnit>{};

    for (final element in allAnnotatedElements) {
      final astNode = await buildStep.resolver.astNodeFor(
        element.firstFragment,
        resolve: true,
      );

      if (astNode == null) continue;

      final compilationUnit = astNode.root as CompilationUnit;
      final sourceUri = compilationUnit.declaredFragment!.source.uri;

      // Use source URI (not library URI) to deduplicate
      // Part files have different source URIs but share library URI
      uniqueCompilationUnits.putIfAbsent(sourceUri, () => compilationUnit);
    }

    return generateForUnit(uniqueCompilationUnits.values.toList());
  }

  FutureOr<String> generateForUnit(List<CompilationUnit> compilationUnits);

  @override
  Stream<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async* {
    final ast = await buildStep.resolver
        .astNodeFor(element.firstFragment, resolve: true)
        .then((value) => value?.root);

    ast as CompilationUnit?;
    if (ast == null) return;

    yield await generateForUnit([ast]);
  }
}
