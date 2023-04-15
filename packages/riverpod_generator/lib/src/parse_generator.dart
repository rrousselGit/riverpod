import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
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
  Future<String> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) async {
    final firstAnnotatedElementFromUniqueSource = <Uri, Element>{};

    for (final annotated in library.annotatedWithExact(typeChecker)) {
      firstAnnotatedElementFromUniqueSource.putIfAbsent(
        annotated.element.source!.uri,
        () => annotated.element,
      );
    }

    final ast = await Future.wait(
      firstAnnotatedElementFromUniqueSource.values.map(
        (e) => buildStep.resolver
            .astNodeFor(e, resolve: true)
            .then((value) => value!.root as CompilationUnit),
      ),
    );

    return generateForUnit(ast);
  }

  FutureOr<String> generateForUnit(List<CompilationUnit> compilationUnits);

  @override
  Stream<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async* {
    final ast = await buildStep.resolver
        .astNodeFor(element, resolve: true)
        .then((value) => value?.root);

    ast as CompilationUnit?;
    if (ast == null) return;

    yield await generateForUnit([ast]);
  }
}
