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
    final elementsBySourceFile = <Uri, Fragment>{};

    for (final annotatedElement in library.annotatedWithExact(
      typeChecker,
      throwOnUnresolved: false,
    )) {
      for (final fragment in annotatedElement.element.fragments) {
        final sourceUri = fragment.libraryFragment?.source.uri;
        if (sourceUri == null) continue;

        elementsBySourceFile.putIfAbsent(sourceUri, () => fragment);
      }
    }

    final compilationUnits = await Future.wait(
      elementsBySourceFile.values.map(
        (element) => buildStep.resolver
            .astNodeFor(element, resolve: true)
            .then((ast) => ast!.root as CompilationUnit),
      ),
    );

    return generateForUnit(compilationUnits);
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
