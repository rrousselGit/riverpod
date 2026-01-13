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
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final fragmentsBySourceFile = <Uri, Fragment>{};

    for (final annotatedElement in library.annotatedWithExact(
      typeChecker,
      throwOnUnresolved: false,
    )) {
      for (final fragment in annotatedElement.element.fragments) {
        final sourceUri = fragment.libraryFragment?.source.uri;
        if (sourceUri == null) continue;
        fragmentsBySourceFile.putIfAbsent(sourceUri, () => fragment);
      }
    }

    final compilationUnits = await Future.wait(
      fragmentsBySourceFile.values.map(
        (fragment) => buildStep.resolver
            .astNodeFor(fragment, resolve: true)
            .then((ast) => ast?.root as CompilationUnit?),
      ),
    ).then((units) => units.nonNulls.toList());

    return generateForUnit(compilationUnits);
  }

  FutureOr<String> generateForUnit(List<CompilationUnit> compilationUnits);

  @override
  Stream<String> generateForAnnotatedElement(
    Element element,
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
