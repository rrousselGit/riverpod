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

  Element2? findElementWithNameFromRiverpod(String name) {
    return _fragment!.importedLibraries2
        .map((e) => e.exportNamespace.get2(name))
        .firstWhereOrNull(
          (element) => element != null && isFromRiverpod.isExactly(element),
        );
  }

  ClassElement2? findAsyncValue() {
    final cache = _asyncValueCache[this];
    if (cache != null) return cache;

    final result = findElementWithNameFromRiverpod('AsyncValue');
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
