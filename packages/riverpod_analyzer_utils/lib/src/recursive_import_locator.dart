// Copied from Freezed

import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Exposes utilities to determine whether an element is accessible within a library
extension FindAccessibleElementsLibraryElementExtension on LibraryElement {
  /// Recursively loops at the import/export directives to know what is available
  /// in the library.
  ///
  /// This function does not guarantees that the elements returned are unique.
  /// It is possible for the same object to be present multiple times in the list.
  Iterable<Element> findAllAvailableTopLevelElements() {
    return _findAllAvailableTopLevelElements(
      {},
      checkExports: false,
      key: _LibraryKey(
        hideStatements: const {},
        showStatements: const {},
        librarySource: librarySource.fullName,
      ),
    );
  }

  Iterable<Element> _findAllAvailableTopLevelElements(
    Set<_LibraryKey> visitedLibraryPaths, {
    required bool checkExports,
    required _LibraryKey key,
  }) sync* {
    yield* topLevelElements;

    final librariesToCheck = checkExports
        ? libraryExports.map(_LibraryDirectives.fromExport).whereNotNull()
        : libraryImports.map(_LibraryDirectives.fromImport).whereNotNull();

    for (final directive in librariesToCheck) {
      if (!visitedLibraryPaths.add(directive.key)) {
        continue;
      }

      yield* directive.library
          ._findAllAvailableTopLevelElements(
        visitedLibraryPaths,
        checkExports: true,
        key: directive.key,
      )
          .where(
        (element) {
          return (directive.showStatements.isEmpty &&
                  directive.hideStatements.isEmpty) ||
              (directive.hideStatements.isNotEmpty &&
                  !directive.hideStatements.contains(element.name)) ||
              directive.showStatements.contains(element.name);
        },
      );
    }
  }
}

class _LibraryDirectives {
  _LibraryDirectives({
    required this.hideStatements,
    required this.showStatements,
    required this.library,
  });

  static _LibraryDirectives? fromExport(LibraryExportElement export) {
    final library = export.exportedLibrary;
    if (library == null) return null;

    final hideStatements = export.combinators
        .whereType<HideElementCombinator>()
        .expand((e) => e.hiddenNames)
        .toSet();

    final showStatements = export.combinators
        .whereType<ShowElementCombinator>()
        .expand((e) => e.shownNames)
        .toSet();

    return _LibraryDirectives(
      hideStatements: hideStatements,
      showStatements: showStatements,
      library: library,
    );
  }

  static _LibraryDirectives? fromImport(LibraryImportElement export) {
    final library = export.importedLibrary;
    if (library == null) return null;

    final hideStatements = export.combinators
        .whereType<HideElementCombinator>()
        .expand((e) => e.hiddenNames)
        .toSet();

    final showStatements = export.combinators
        .whereType<ShowElementCombinator>()
        .expand((e) => e.shownNames)
        .toSet();

    return _LibraryDirectives(
      hideStatements: hideStatements,
      showStatements: showStatements,
      library: library,
    );
  }

  final Set<String> hideStatements;
  final Set<String> showStatements;
  final LibraryElement library;

  _LibraryKey get key {
    return _LibraryKey(
      hideStatements: hideStatements,
      showStatements: showStatements,
      librarySource: library.source.fullName,
    );
  }
}

/// A unique key for an import/export statement, to avoid visiting a library twice
/// as libraries sometimes have circular dependencies – which would cause an infinite loop.
///
/// We can't simply use the library path, as it's possible for the same library
/// to be exported multiple time:
///
/// ```dart
/// export 'library.dart' show A;
/// export 'library.dart' show B;
/// ```
@immutable
class _LibraryKey {
  const _LibraryKey({
    required this.hideStatements,
    required this.showStatements,
    required this.librarySource,
  });

  final Set<String> hideStatements;
  final Set<String> showStatements;
  final String librarySource;

  @override
  bool operator ==(Object? other) {
    return other is _LibraryKey &&
        librarySource == other.librarySource &&
        const SetEquality<String>()
            .equals(hideStatements, other.hideStatements) &&
        const SetEquality<String>()
            .equals(showStatements, other.showStatements);
  }

  @override
  int get hashCode => Object.hash(
        librarySource,
        const SetEquality<String>().hash(hideStatements),
        const SetEquality<String>().hash(showStatements),
      );

  @override
  String toString() {
    return '(path: $librarySource, hide: $hideStatements, show: $showStatements)';
  }
}
