// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Code imported from source_gen

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';

/// An abstraction around doing static type checking at compile/build time.
abstract class TypeChecker {
  const TypeChecker._();

  /// Creates a new [TypeChecker] that delegates to other [checkers].
  ///
  /// This implementation will return `true` for type checks if _any_ of the
  /// provided type checkers return true, which is useful for deprecating an
  /// API:
  /// ```dart
  /// const $Foo = const TypeChecker.fromRuntime(Foo);
  /// const $Bar = const TypeChecker.fromRuntime(Bar);
  ///
  /// // Used until $Foo is deleted.
  /// const $FooOrBar = const TypeChecker.forAny(const [$Foo, $Bar]);
  /// ```
  const factory TypeChecker.any(Iterable<TypeChecker> checkers) = _AnyChecker;

  /// Creates a new [TypeChecker] that delegates to other [checkers].
  ///
  /// This implementation will return `true` if **all** the checkers match.
  /// Checkers will be checked in order.
  const factory TypeChecker.every(Iterable<TypeChecker> checkers) =
      _EveryChecker;

  /// Create a new [TypeChecker] backed by a static [type].
  const factory TypeChecker.fromStatic(DartType type) = _LibraryTypeChecker;

  /// Checks that the element comes from a specific package.
  const factory TypeChecker.fromPackage(String packageName) = _PackageChecker;

  /// Checks that the element has a specific name, and optionally checks that it
  /// is defined from a specific package.
  ///
  /// This is similar to [TypeChecker.fromUrl] but does not rely on exactly where
  /// the definition of the element comes from.
  /// The downside is that if somehow a package exposes two elements with the
  /// same name, there could be a conflict.
  const factory TypeChecker.fromName(
    String name, {
    String? packageName,
  }) = _NamedChecker;

  /// Create a new [TypeChecker] backed by a library [url].
  ///
  /// Example of referring to a `LinkedHashMap` from `dart:collection`:
  /// ```dart
  /// const linkedHashMap = const TypeChecker.fromUrl(
  ///   'dart:collection#LinkedHashMap',
  /// );
  /// ```
  ///
  /// **NOTE**: This is considered a more _brittle_ way of determining the type
  /// because it relies on knowing the _absolute_ path (i.e. after resolved
  /// `export` directives). You should ideally only use `fromUrl` when you know
  /// the full path (likely you own/control the package) or it is in a stable
  /// package like in the `dart:` SDK.
  const factory TypeChecker.fromUrl(dynamic url) = _UriTypeChecker;

  /// Returns the first constant annotating [element] assignable to this type.
  ///
  /// Otherwise returns `null`.
  ///
  /// Throws on unresolved annotations unless [throwOnUnresolved] is `false`.
  DartObject? firstAnnotationOf(
    Element element, {
    bool throwOnUnresolved = true,
  }) {
    if (element.metadata.isEmpty) {
      return null;
    }
    final results =
        annotationsOf(element, throwOnUnresolved: throwOnUnresolved);
    return results.isEmpty ? null : results.first;
  }

  /// Returns if a constant annotating [element] is assignable to this type.
  ///
  /// Throws on unresolved annotations unless [throwOnUnresolved] is `false`.
  bool hasAnnotationOf(Element element, {bool throwOnUnresolved = true}) =>
      firstAnnotationOf(element, throwOnUnresolved: throwOnUnresolved) != null;

  /// Returns the first constant annotating [element] that is exactly this type.
  ///
  /// Throws [UnresolvedAnnotationException] on unresolved annotations unless
  /// [throwOnUnresolved] is explicitly set to `false` (default is `true`).
  DartObject? firstAnnotationOfExact(
    Element element, {
    bool throwOnUnresolved = true,
  }) {
    if (element.metadata.isEmpty) {
      return null;
    }
    final results =
        annotationsOfExact(element, throwOnUnresolved: throwOnUnresolved);
    return results.isEmpty ? null : results.first;
  }

  /// Returns if a constant annotating [element] is exactly this type.
  ///
  /// Throws [UnresolvedAnnotationException] on unresolved annotations unless
  /// [throwOnUnresolved] is explicitly set to `false` (default is `true`).
  bool hasAnnotationOfExact(Element element, {bool throwOnUnresolved = true}) =>
      firstAnnotationOfExact(element, throwOnUnresolved: throwOnUnresolved) !=
      null;

  DartObject? _computeConstantValue(
    Element element,
    int annotationIndex, {
    bool throwOnUnresolved = true,
  }) {
    final annotation = element.metadata[annotationIndex];
    final result = annotation.computeConstantValue();
    if (result == null && throwOnUnresolved) {
      throw UnresolvedAnnotationException._from(element, annotationIndex);
    }
    return result;
  }

  /// Returns annotating constants on [element] assignable to this type.
  ///
  /// Throws [UnresolvedAnnotationException] on unresolved annotations unless
  /// [throwOnUnresolved] is explicitly set to `false` (default is `true`).
  Iterable<DartObject> annotationsOf(
    Element element, {
    bool throwOnUnresolved = true,
  }) =>
      _annotationsWhere(
        element,
        isAssignableFromType,
        throwOnUnresolved: throwOnUnresolved,
      );

  Iterable<DartObject> _annotationsWhere(
    Element element,
    bool Function(DartType) predicate, {
    bool throwOnUnresolved = true,
  }) sync* {
    for (var i = 0; i < element.metadata.length; i++) {
      final value = _computeConstantValue(
        element,
        i,
        throwOnUnresolved: throwOnUnresolved,
      );
      if (value?.type != null && predicate(value!.type!)) {
        yield value;
      }
    }
  }

  /// Returns annotating constants on [element] of exactly this type.
  ///
  /// Throws [UnresolvedAnnotationException] on unresolved annotations unless
  /// [throwOnUnresolved] is explicitly set to `false` (default is `true`).
  Iterable<DartObject> annotationsOfExact(
    Element element, {
    bool throwOnUnresolved = true,
  }) =>
      _annotationsWhere(
        element,
        isExactlyType,
        throwOnUnresolved: throwOnUnresolved,
      );

  /// Returns `true` if the type of [element] can be assigned to this type.
  bool isAssignableFrom(Element element) =>
      isExactly(element) ||
      (element is ClassElement && element.allSupertypes.any(isExactlyType));

  /// Returns `true` if [staticType] can be assigned to this type.
  // ignore: avoid_bool_literals_in_conditional_expressions
  bool isAssignableFromType(DartType staticType) => staticType.element == null
      ? false
      : isAssignableFrom(staticType.element!);

  /// Returns `true` if representing the exact same class as [element].
  bool isExactly(Element element);

  /// Returns `true` if representing the exact same type as [staticType].
  bool isExactlyType(DartType staticType) {
    final element = staticType.element;
    return element != null && isExactly(element);
  }

  /// Returns `true` if representing a super class of [element].
  ///
  /// This check only takes into account the *extends* hierarchy. If you wish
  /// to check mixins and interfaces, use [isAssignableFrom].
  bool isSuperOf(Element element) {
    if (element is ClassElement) {
      var theSuper = element.supertype;

      do {
        if (isExactlyType(theSuper!)) {
          return true;
        }

        theSuper = theSuper.superclass;
      } while (theSuper != null);
    }

    return false;
  }

  /// Returns `true` if representing a super type of [staticType].
  ///
  /// This only takes into account the *extends* hierarchy. If you wish
  /// to check mixins and interfaces, use [isAssignableFromType].
  bool isSuperTypeOf(DartType staticType) => isSuperOf(staticType.element!);
}

// Checks a static type against another static type;
class _LibraryTypeChecker extends TypeChecker {
  const _LibraryTypeChecker(this._type) : super._();

  final DartType _type;

  @override
  bool isExactly(Element element) =>
      element is ClassElement && element == _type.element;

  @override
  String toString() => _urlOfElement(_type.element!);
}

@immutable
class _PackageChecker extends TypeChecker {
  const _PackageChecker(this._packageName) : super._();

  final String _packageName;

  @override
  bool isExactly(Element element) {
    final elementLibraryIdentifier = element.library?.identifier;

    return elementLibraryIdentifier != null &&
        elementLibraryIdentifier.startsWith('package:$_packageName/');
  }

  @override
  bool operator ==(Object o) {
    return o is _PackageChecker && o._packageName == _packageName;
  }

  @override
  int get hashCode => Object.hash(runtimeType, _packageName);

  @override
  String toString() => _packageName;
}

@immutable
class _NamedChecker extends TypeChecker {
  const _NamedChecker(this._name, {this.packageName}) : super._();

  final String _name;
  final String? packageName;

  @override
  bool isExactly(Element element) {
    if (element.name != _name) return false;

    // No packageName specified, ignoring it.
    if (packageName == null) return true;

    final checker = _PackageChecker(packageName!);
    return checker.isExactly(element);
  }

  @override
  bool operator ==(Object o) {
    return o is _NamedChecker &&
        o._name == _name &&
        o.packageName == packageName;
  }

  @override
  int get hashCode => Object.hash(runtimeType, _name, packageName);

  @override
  String toString() => '$packageName#$_name';
}

// Checks a runtime type against an Uri and Symbol.
@immutable
class _UriTypeChecker extends TypeChecker {
  const _UriTypeChecker(dynamic url)
      : _url = '$url',
        super._();

  // Precomputed cache of String --> Uri.
  static final _cache = Expando<Uri>();

  final String _url;

  /// Url as a [Uri] object, lazily constructed.
  Uri get uri => _cache[this] ??= _normalizeUrl(Uri.parse(_url));

  /// Returns whether this type represents the same as [url].
  bool hasSameUrl(dynamic url) =>
      uri.toString() ==
      (url is String ? url : _normalizeUrl(url as Uri).toString());

  @override
  bool isExactly(Element element) => hasSameUrl(_urlOfElement(element));

  @override
  bool operator ==(Object o) => o is _UriTypeChecker && o._url == _url;

  @override
  int get hashCode => _url.hashCode;

  @override
  String toString() => '$uri';
}

class _AnyChecker extends TypeChecker {
  const _AnyChecker(this._checkers) : super._();

  final Iterable<TypeChecker> _checkers;

  @override
  bool isExactly(Element element) => _checkers.any((c) => c.isExactly(element));
}

class _EveryChecker extends TypeChecker {
  const _EveryChecker(this._checkers) : super._();

  final Iterable<TypeChecker> _checkers;

  @override
  bool isExactly(Element element) {
    return _checkers.every((c) => c.isExactly(element));
  }
}

/// Exception thrown when [TypeChecker] fails to resolve a metadata annotation.
///
/// Methods such as [TypeChecker.firstAnnotationOf] may throw this exception
/// when one or more annotations are not resolvable. This is usually a sign that
/// something was misspelled, an import is missing, or a dependency was not
/// defined (for build systems such as Bazel).
class UnresolvedAnnotationException implements Exception {
  /// Creates an exception from an annotation ([annotationIndex]) that was not
  /// resolvable while traversing [Element.metadata] on [annotatedElement].
  factory UnresolvedAnnotationException._from(
    Element annotatedElement,
    int annotationIndex,
  ) {
    final sourceSpan = _findSpan(annotatedElement, annotationIndex);
    return UnresolvedAnnotationException._(annotatedElement, sourceSpan);
  }

  const UnresolvedAnnotationException._(
    this.annotatedElement,
    this.annotationSource,
  );

  static SourceSpan? _findSpan(
    Element annotatedElement,
    int annotationIndex,
  ) {
    final parsedLibrary = annotatedElement.session!
            .getParsedLibraryByElement(annotatedElement.library!)
        as ParsedLibraryResult;
    final declaration = parsedLibrary.getElementDeclaration(annotatedElement);
    if (declaration == null) {
      return null;
    }
    final node = declaration.node;
    final List<Annotation> metadata;
    if (node is AnnotatedNode) {
      metadata = node.metadata;
    } else if (node is FormalParameter) {
      metadata = node.metadata;
    } else {
      throw StateError(
        'Unhandled Annotated AST node type: ${node.runtimeType}',
      );
    }
    final annotation = metadata[annotationIndex];
    final start = annotation.offset;
    final end = start + annotation.length;
    final parsedUnit = declaration.parsedUnit!;
    return SourceSpan(
      SourceLocation(start, sourceUrl: parsedUnit.uri),
      SourceLocation(end, sourceUrl: parsedUnit.uri),
      parsedUnit.content.substring(start, end),
    );
  }

  /// Element that was annotated with something we could not resolve.
  final Element annotatedElement;

  /// Source span of the annotation that was not resolved.
  ///
  /// May be `null` if the import library was not found.
  final SourceSpan? annotationSource;

  @override
  String toString() {
    final message = 'Could not resolve annotation for `$annotatedElement`.';
    if (annotationSource != null) {
      return annotationSource!.message(message);
    }
    return message;
  }
}

/// Returns a URL representing [element].
String _urlOfElement(Element element) => element.kind == ElementKind.DYNAMIC
    ? 'dart:core#dynamic'
    : element.kind == ElementKind.NEVER
        ? 'dart:core#Never'
        // using librarySource.uri – in case the element is in a part
        : _normalizeUrl(element.librarySource!.uri)
            .replace(fragment: element.name)
            .toString();

Uri _normalizeUrl(Uri url) {
  switch (url.scheme) {
    case 'dart':
      return _normalizeDartUrl(url);
    case 'package':
      return _packageToAssetUrl(url);
    case 'file':
      return _fileToAssetUrl(url);
    default:
      return url;
  }
}

/// Make `dart:`-type URLs look like a user-knowable path.
///
/// Some internal dart: URLs are something like `dart:core/map.dart`.
///
/// This isn't a user-knowable path, so we strip out extra path segments
/// and only expose `dart:core`.
Uri _normalizeDartUrl(Uri url) => url.pathSegments.isNotEmpty
    ? url.replace(pathSegments: url.pathSegments.take(1))
    : url;

Uri _fileToAssetUrl(Uri url) {
  if (!p.isWithin(p.url.current, url.path)) return url;

  return Uri(
    scheme: 'asset',
    path: p.join('', p.relative(url.path)),
  );
}

/// Returns a `package:` URL converted to a `asset:` URL.
///
/// This makes internal comparison logic much easier, but still allows users
/// to define assets in terms of `package:`, which is something that makes more
/// sense to most.
///
/// For example, this transforms `package:source_gen/source_gen.dart` into:
/// `asset:source_gen/lib/source_gen.dart`.
Uri _packageToAssetUrl(Uri url) => url.scheme == 'package'
    ? url.replace(
        scheme: 'asset',
        pathSegments: <String>[
          url.pathSegments.first,
          'lib',
          ...url.pathSegments.skip(1),
        ],
      )
    : url;
