import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'errors.dart';
import 'riverpod_types.dart';

@internal
extension LibraryElementX on CompilationUnit {
  static final _asyncValueCache = Expando<ClassElement>();

  LibraryElement? get _library => declaredElement?.library;

  Element? findElementWithNameFromRiverpod(String name) {
    return _library!.importedLibraries
        .map((e) => e.exportNamespace.get(name))
        .firstWhereOrNull(
          (element) => element != null && isFromRiverpod.isExactly(element),
        );
  }

  ClassElement? findAsyncValue() {
    final cache = _asyncValueCache[this];
    if (cache != null) return cache;

    final result = findElementWithNameFromRiverpod('AsyncValue');
    if (result == null) {
      errorReporter(
        RiverpodAnalysisError(
          'No AsyncValue accessible in the library. '
          'Did you forget to import Riverpod?',
          targetNode: this,
          code: null,
        ),
      );
      return null;
    }

    return _asyncValueCache[this] = result as ClassElement?;
  }

  DartType? createdTypeToValueType(DartType? typeArg) {
    final asyncValue = findAsyncValue();

    return asyncValue?.instantiate(
      typeArguments: [if (typeArg != null) typeArg],
      nullabilitySuffix: NullabilitySuffix.none,
    );
  }
}
