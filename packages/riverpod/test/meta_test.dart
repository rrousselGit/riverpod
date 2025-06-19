import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
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

    final result = await resolveFile2(path: absolute);
    result as ResolvedUnitResult;

    riverpod = result.libraryElement.importedLibraries.firstWhere(
      (e) => e.source.uri.toString() == 'package:riverpod/riverpod.dart',
    );
    visitor = _PublicAPIVisitor(riverpod);

    riverpod.accept(visitor);
    for (final publicApi in riverpod.exportNamespace.definedNames.values) {
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

class _PublicAPIVisitor extends GeneralizingElementVisitor<void> {
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
      for (final parameter in type.parameters) {
        _verifyTypeIsExported(parameter.type, element);
      }
      return;
    }

    if (type.isCore) return;

    final key = type.element?.name ?? '';
    if (!riverpod.exportNamespace.definedNames.containsKey(key)) {
      unexportedElements.add('${element.location}#$key');
    }
  }

  void _verifyHasDocs(Element element) {
    if (element.documentationComment?.isNotEmpty != true) {
      undocumentedElements.add('${element.location}');
    }
  }

  bool _isPublicApi(Element element) {
    if (element.isPrivate) return false;
    // Is part of an @internal element
    if (element.thisOrAncestorMatching((e) => e.hasInternal) != null) {
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
    final parent = element.enclosingElement3;

    if (parent is! ClassElement) return;

    final overrides = parent.allSupertypes
        .map((e) {
          if (element is MethodElement) {
            return e.getMethod(element.name);
          } else if (element is PropertyAccessorElement && element.isGetter) {
            return e.getGetter(element.name);
          } else if (element is PropertyAccessorElement && element.isSetter) {
            return e.getSetter(element.name);
          }
        })
        .nonNulls
        .toList();

    if (overrides.isEmpty) return;

    for (final override in overrides) {
      if (element.hasChangePrivacy) continue;
      if ((!element.hasInternal && override.hasInternal) ||
          (!element.hasProtected && override.hasProtected) ||
          (!element.hasVisibleForOverriding &&
              override.hasVisibleForOverriding) ||
          (!element.hasVisibleForTesting && override.hasVisibleForTesting)) {
        missingInheritedAnnotations.add(
          '${element.location} vs ${override.location}\n'
          '${element.metadata} vs ${override.metadata}',
        );
      }
    }
  }

  void _parseTemplatesAndMacros(Element element) {
    final docs = element.documentationComment;
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
    return metadata.any((e) => e.element?.name == 'changePrivacy');
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

    return element.librarySource?.uri.toString().startsWith('dart:') ?? false;
  }
}
