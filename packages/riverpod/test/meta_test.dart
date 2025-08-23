import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/element/element2.dart';
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

  late final LibraryElement2 riverpod;
  late final _PublicAPIVisitor visitor;

  setUpAll(() async {
    const file = './example/lib/main.dart';
    final absolute = path.normalize(path.absolute(file));

    final result = await resolveFile2(path: absolute);
    result as ResolvedUnitResult;

    riverpod = result.libraryFragment.importedLibraries2.firstWhere(
      (e) => e.uri.toString() == 'package:riverpod/riverpod.dart',
    );
    visitor = _PublicAPIVisitor(riverpod);

    riverpod.accept2(visitor);
    for (final publicApi in riverpod.exportNamespace.definedNames2.values) {
      publicApi.accept2(visitor);
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

  final LibraryElement2 riverpod;
  final missingInheritedAnnotations = <String>{};
  final unexportedElements = <String>{};
  final undocumentedElements = <String>{};

  final templates = <String>{};
  final duplicateTemplates = <String>{};
  final macros = <String>{};

  void _verifyTypeIsExported(DartType type, VariableElement2 element) {
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

    final key = type.element3?.name3 ?? '';
    if (!riverpod.exportNamespace.definedNames2.containsKey(key)) {
      unexportedElements.add('${element.library2!.uri}#$key');
    }
  }

  void _verifyHasDocs(Element2 element) {
    final Object annotatable = element;
    if (annotatable is! Annotatable) return;

    if (annotatable.documentationComment?.isNotEmpty != true) {
      undocumentedElements.add('${element.library2!.uri}');
    }
  }

  bool _isPublicApi(Element2 element) {
    if (element.isPrivate) return false;
    // Is part of an @internal element
    if (element.thisOrAncestorMatching2((e) {
          final Object obj = e;
          return obj is Annotatable && obj.metadata2.hasInternal;
        }) !=
        null) {
      return false;
    }

    return true;
  }

  @override
  void visitElement(Element2 element) {
    super.visitElement(element);

    if (_isPublicApi(element)) {
      _verifyInheritsAnnotations(element);
      _verifyHasDocs(element);
      _parseTemplatesAndMacros(element);
    }
  }

  @override
  void visitClassElement(ClassElement2 element) {
    super.visitClassElement(element);

    // Verify that inherited members also respect public API constraints
    for (final superType in element.allSupertypes) {
      visitElement(element);
    }
  }

  @override
  void visitVariableElement(VariableElement2 element) {
    super.visitVariableElement(element);

    _verifyTypeIsExported(element.type, element);
  }

  void _verifyInheritsAnnotations(Element2 element) {
    final annotatable = element as Annotatable;
    final parent = element.enclosingElement2;

    if (parent is! ClassElement2) return;

    final overrides = parent.allSupertypes
        .map((e) {
          final name = element.name3!;
          final override =
              e.getMethod2(name) ?? e.getGetter2(name) ?? e.getSetter2(name);

          if (override == null) return null;

          return (override, e.element3.name3!);
        })
        .nonNulls
        .toList();

    if (overrides.isEmpty) return;

    for (final (override, className) in overrides) {
      if (annotatable.hasChangePrivacy) continue;
      if ((!annotatable.metadata2.hasInternal &&
              override.metadata2.hasInternal) ||
          (!annotatable.metadata2.hasProtected &&
              override.metadata2.hasProtected) ||
          (!annotatable.metadata2.hasVisibleForOverriding &&
              override.metadata2.hasVisibleForOverriding) ||
          (!annotatable.metadata2.hasVisibleForTesting &&
              override.metadata2.hasVisibleForTesting)) {
        missingInheritedAnnotations.add(
          '${element.library2!.uri}#${element.enclosingElement2!.name3}.${element.name3} vs ${override.library2.uri}#$className.${override.name3}',
        );
      }
    }
  }

  void _parseTemplatesAndMacros(Element2 element) {
    final Object annotatable = element;
    if (annotatable is! Annotatable) return;

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

extension on Annotatable {
  bool get hasChangePrivacy {
    return metadata2.annotations
        .any((e) => e.element2?.name3 == 'changePrivacy');
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

    final element = element3;
    if (element == null) return false;

    return element.library2?.uri.toString().startsWith('dart:') ?? false;
  }
}
