import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'errors.dart';
import 'riverpod_types.dart';

@internal
extension LibraryElement2X on CompilationUnit {
  static final _asyncValueCache = Expando<ClassElement2>();

  LibraryFragment? get _fragment => declaredFragment;

  Iterable<LibraryElement2> _recursivelyListAllImportedLibraries() sync* {
    final visited = <Uri>{};
    final queue = <LibraryElement2>[_fragment!.element];

    while (queue.isNotEmpty) {
      final current = queue.removeLast();
      if (visited.contains(current.uri)) continue;
      visited.add(current.uri);

      yield current;

      for (final fragment in current.fragments) {
        queue.addAll(
          fragment.libraryImports2
              .map((import) => import.importedLibrary2)
              .nonNulls,
        );
        queue.addAll(
          fragment.libraryExports2
              .map((export) => export.exportedLibrary2)
              .nonNulls,
        );
      }
    }
  }

  Element2? _findElementWithName(
    String name, {
    bool Function(Element2? element)? where,
  }) {
    var result = _fragment!.libraryImports2
        .map((e) => e.namespace.definedNames2[name])
        .nonNulls
        .followedBy(
          _recursivelyListAllImportedLibraries()
              .map((e) => e.exportNamespace.definedNames2[name])
              .nonNulls,
        );

    if (where != null) result = result.where(where);

    return result.firstOrNull;
  }

  Element2? _findElementWithNameFromRiverpod(String name) {
    return _findElementWithName(
      name,
      where: (element) => element != null && isFromRiverpod.isExactly(element),
    );
  }

  ClassElement2? findAsyncValue() {
    final cache = _asyncValueCache[this];
    if (cache != null) return cache;

    final result = _findElementWithNameFromRiverpod('AsyncValue');
    if (result == null) {
      errorReporter(
        RiverpodAnalysisError.ast(
          'No AsyncValue accessible in the library. '
          'Did you forget to import Riverpod?',
          targetNode: this,
          code: null,
        ),
      );
      return null;
    }

    return _asyncValueCache[this] = result as ClassElement2?;
  }

  DartType? createdTypeToValueType(DartType? typeArg) {
    final asyncValue = findAsyncValue();

    return asyncValue?.instantiate(
      typeArguments: [if (typeArg != null) typeArg],
      nullabilitySuffix: NullabilitySuffix.none,
    );
  }
}
