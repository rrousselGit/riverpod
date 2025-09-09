import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor2.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  // This verifies that:
  // - All public APIs are documented
  // - public APIs have no unexported types
  // - {@template} are not duplicated
  // - all {@template} are used
  // - all {@macro} have an associated {@template}

  late final LibraryElement riverpod;
  late final _PublicAPIVisitor visitor;

  setUpAll(() async {
    const file = './example/lib/main.dart';
    final absolute = path.normalize(path.absolute(file));

    final result = await resolveFile(path: absolute);
    result as ResolvedUnitResult;

    riverpod = result.libraryFragment.importedLibraries.firstWhere(
      (e) => e.uri.toString() == 'package:riverpod/riverpod.dart',
    );
    visitor = _PublicAPIVisitor(riverpod);

    riverpod.accept(visitor);
    for (final publicApi in riverpod.exportNamespace.definedNames2.values) {
      publicApi.accept(visitor);
    }
  });

  test('overrides re-apply annotations', () async {
    expect(visitor.missingInheritedAnnotations, isEmpty);
  });

  test('public API does not contain unexported elements', skip: 'Disabled', () {
    expect(visitor.unexportedElements, isEmpty);
  });

  test('all public APIs are documented', skip: 'Disabled', () {
    expect(visitor.undocumentedElements, isEmpty);
  });

  test('all templates are used', skip: 'Disabled', () {
    expect(visitor.duplicateTemplates, isEmpty, reason: 'Duplicate templates');
    for (final template in visitor.templates) {
      expect(visitor.macros, contains(template), reason: 'Unused template');
    }
    for (final macro in visitor.macros) {
      expect(visitor.templates, contains(macro), reason: 'Missing template');
    }
  });
}

class _PublicAPIVisitor extends GeneralizingElementVisitor2<void> {
  _PublicAPIVisitor(this.riverpod);

  final LibraryElement riverpod;
  final missingInheritedAnnotations = <String>{};
  final unexportedElements = <String>{};
  final undocumentedElements = <String>{};

  final templates = <String>{};
  final duplicateTemplates = <String>{};
  final macros = <String>{};

  void _verifyTypeIsExported(DartType type, VariableElement element) {
    if (type is TypeParameterType) {
      _verifyTypeIsExported(type.bound, element);
      return;
    }

    if (type is FunctionType) {
      _verifyTypeIsExported(type.returnType, element);
      for (final parameter in type.formalParameters) {
        _verifyTypeIsExported(parameter.type, element);
      }
      return;
    }

    if (type.isCore) return;

    final key = type.element?.name ?? '';
    if (!riverpod.exportNamespace.definedNames2.containsKey(key)) {
      unexportedElements.add('${element.library!.uri}#$key');
    }
  }

  void _verifyHasDocs(Element element) {
    final Object annotatable = element;
    if (annotatable is! Element) return;

    if (annotatable.documentationComment?.isNotEmpty != true) {
      undocumentedElements.add('${element.library!.uri}');
    }
  }

  bool _isPublicApi(Element element) {
    if (element.isPrivate) return false;
    // Is part of an @internal element
    if (element.thisOrAncestorMatching((e) {
          final Object obj = e;
          return obj is Element && obj.metadata.hasInternal;
        }) !=
        null) {
      return false;
    }

    return true;
  }

  @override
  void visitElement(Element element) {
    super.visitElement(element);

    if (_isPublicApi(element)) {
      _verifyInheritsAnnotations(element);
      _verifyHasDocs(element);
      _parseTemplatesAndMacros(element);
    }
  }

  @override
  void visitClassElement(ClassElement element) {
    super.visitClassElement(element);

    // Verify that inherited members also respect public API constraints
    for (final superType in element.allSupertypes) {
      visitElement(element);
    }
  }

  @override
  void visitVariableElement(VariableElement element) {
    super.visitVariableElement(element);

    _verifyTypeIsExported(element.type, element);
  }

  void _verifyInheritsAnnotations(Element element) {
    final annotatable = element;
    final parent = element.enclosingElement;

    if (parent is! ClassElement) return;

    final overrides = parent.allSupertypes
        .map((e) {
          final name = element.name!;
          final override =
              e.getMethod(name) ?? e.getGetter(name) ?? e.getSetter(name);

          if (override == null) return null;

          return (override, e.element.name!);
        })
        .nonNulls
        .toList();

    if (overrides.isEmpty) return;

    for (final (override, className) in overrides) {
      if (annotatable.hasChangePrivacy) continue;
      if ((!annotatable.metadata.hasInternal &&
              override.metadata.hasInternal) ||
          (!annotatable.metadata.hasProtected &&
              override.metadata.hasProtected) ||
          (!annotatable.metadata.hasVisibleForOverriding &&
              override.metadata.hasVisibleForOverriding) ||
          (!annotatable.metadata.hasVisibleForTesting &&
              override.metadata.hasVisibleForTesting)) {
        missingInheritedAnnotations.add(
          '${element.library!.uri}#${element.enclosingElement!.name}.${element.name} vs ${override.library.uri}#$className.${override.name}',
        );
      }
    }
  }

  void _parseTemplatesAndMacros(Element element) {
    final Object annotatable = element;
    if (annotatable is! Element) return;

    final docs = annotatable.documentationComment;
    if (docs == null) return;

    final regExp = RegExp(r'{@(\w+) (\S+)}', multiLine: true);
    for (final match in regExp.allMatches(docs)) {
      final type = match.group(1)!;
      final name = match.group(2)!;

      if (type == 'template') {
        if (!templates.add(name)) {
          duplicateTemplates.add(name);
        }
      } else if (type == 'macro') {
        macros.add(name);
      }
    }
  }
}

extension on Element {
  bool get hasChangePrivacy {
    return metadata.annotations.any((e) => e.element?.name == 'changePrivacy');
  }
}

extension on DartType {
  /// If it is from the Dart SDK
  bool get isCore {
    if (this is DynamicType ||
        this is VoidType ||
        isDartAsyncFuture ||
        isDartAsyncFutureOr ||
        isDartAsyncStream ||
        isDartCoreBool ||
        isDartCoreDouble ||
        isDartCoreEnum ||
        isDartCoreFunction ||
        isDartCoreInt ||
        isDartCoreIterable ||
        isDartCoreList ||
        isDartCoreMap ||
        isDartCoreNull ||
        isDartCoreNum ||
        isDartCoreObject ||
        isDartCoreRecord ||
        isDartCoreSet ||
        isDartCoreString ||
        isDartCoreSymbol ||
        isDartCoreType) {
      return true;
    }

    final element = this.element;
    if (element == null) return false;

    return element.library?.uri.toString().startsWith('dart:') ?? false;
  }
}
