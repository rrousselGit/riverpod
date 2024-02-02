import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

// ignore: implementation_imports, safe as we are the one controlling this file
import 'package:riverpod_annotation/src/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';
import 'templates/family.dart';
import 'templates/hash.dart';
import 'templates/notifier.dart';
import 'templates/provider.dart';
import 'templates/provider_variable.dart';
import 'templates/ref.dart';

const riverpodTypeChecker = TypeChecker.fromRuntime(Riverpod);

String providerDocFor(Element element) {
  return element.documentationComment == null
      ? '/// See also [${element.name}].'
      : '${element.documentationComment}\n///\n/// Copied from [${element.name}].';
}

String metaAnnotations(NodeList<Annotation> metadata) {
  final buffer = StringBuffer();
  for (final annotation in metadata) {
    final element = annotation.elementAnnotation;
    if (element == null) continue;
    if (element.isDeprecated ||
        element.isVisibleForTesting ||
        element.isProtected) {
      buffer.writeln('$annotation');
      continue;
    }
  }

  return buffer.toString();
}

const _defaultProviderNameSuffix = 'Provider';

/// May be thrown by generators during [Generator.generate].
class RiverpodInvalidGenerationSourceError
    extends InvalidGenerationSourceError {
  RiverpodInvalidGenerationSourceError(
    super.message, {
    super.todo = '',
    super.element,
    this.astNode,
  });

  final AstNode? astNode;

// TODO override toString to render AST nodes.
}

@immutable
class RiverpodGenerator extends ParserGenerator<Riverpod> {
  RiverpodGenerator(Map<String, Object?> mapConfig)
      : options = BuildYamlOptions.fromMap(mapConfig);

  final BuildYamlOptions options;

  @override
  String generateForUnit(List<CompilationUnit> compilationUnits) {
    final riverpodResult = ResolvedRiverpodLibraryResult.from(compilationUnits);
    return runGenerator(riverpodResult);
  }

  String runGenerator(ResolvedRiverpodLibraryResult riverpodResult) {
    for (final error in riverpodResult.errors) {
      throw RiverpodInvalidGenerationSourceError(
        error.message,
        element: error.targetElement,
        astNode: error.targetNode,
      );
    }

    final buffer = StringBuffer();

    riverpodResult.visitChildren(_RiverpodGeneratorVisitor(buffer, options));

    // Only emit the header if we actually generated something
    if (buffer.isNotEmpty) {
      buffer.writeln(
        r"const $kDebugMode = bool.fromEnvironment('dart.vm.product');",
      );

      buffer.write('''
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
''');
    }

    return buffer.toString();
  }
}

class _RiverpodGeneratorVisitor extends RecursiveRiverpodAstVisitor {
  _RiverpodGeneratorVisitor(this.buffer, this.options);

  final StringBuffer buffer;
  final BuildYamlOptions options;

  String get suffix => options.providerNameSuffix ?? _defaultProviderNameSuffix;

  String get familySuffix => options.providerFamilyNameSuffix ?? suffix;

  void visitGeneratorProviderDeclaration(
    GeneratorProviderDeclaration provider,
  ) {
    ProviderVariableTemplate(provider, options).run(buffer);
    ProviderTemplate(provider).run(buffer);
    HashFnTemplate(provider).run(buffer);
    FamilyTemplate(provider, options).run(buffer);
  }

  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration provider,
  ) {
    super.visitClassBasedProviderDeclaration(provider);
    visitGeneratorProviderDeclaration(provider);
    NotifierTemplate(provider).run(buffer);
  }

  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration provider,
  ) {
    super.visitFunctionalProviderDeclaration(provider);
    RefTemplate(provider).run(buffer);
    visitGeneratorProviderDeclaration(provider);
  }
}
