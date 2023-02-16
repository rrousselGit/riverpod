import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

/// Forked from build_resolvers
String assetPath(AssetId assetId) {
  return p.posix.join('/${assetId.package}', assetId.path);
}

extension on AnalysisSession {
  Future<ResolvedLibraryResult> _getResolvedUnit(String path) async {
    var i = 0;
    while (i < 3) {
      i++;
      try {
        final unit = await getResolvedLibrary(path);
        return unit as ResolvedLibraryResult;
      } on InconsistentAnalysisException {
        // Retry
      }
    }

    throw StateError(
      'Failed to obtain the unit: too many inconsistent analysis exceptions.',
    );
  }
}

abstract class ParserGenerator extends GeneratorForAnnotation<Annotation> {
  @override
  Future<String> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) async {
    final path = assetPath(buildStep.inputId);
    final unit = await library.element.session._getResolvedUnit(path);
    return generateForUnit(unit);
  }

  FutureOr<String> generateForUnit(ResolvedLibraryResult resolvedLibraryResult);

  @override
  Stream<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async* {
    final path = assetPath(buildStep.inputId);
    final unit = await element.session!._getResolvedUnit(path);
    yield await generateForUnit(unit);
  }
}
