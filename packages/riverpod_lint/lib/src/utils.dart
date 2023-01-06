// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:path/path.dart' as p;

/// Returns a non-null name for the provided [type].
///
/// In newer versions of the Dart analyzer, a `typedef` does not keep the
/// existing `name`, because it is used an alias:
/// ```
/// // Used to return `VoidFunc` for name, is now `null`.
/// typedef VoidFunc = void Function();
/// ```
///
/// This function will return `'VoidFunc'`, unlike [DartType.element.name].
String typeNameOf(DartType type) {
  final aliasElement = type.alias?.element;
  if (aliasElement != null) {
    return aliasElement.name;
  }
  if (type is DynamicType) {
    return 'dynamic';
  }
  if (type is InterfaceType) {
    return type.element.name;
  }
  if (type is TypeParameterType) {
    return type.element.name;
  }
  throw UnimplementedError('(${type.runtimeType}) $type');
}

bool hasExpectedPartDirective(CompilationUnit unit, String part) =>
    unit.directives
        .whereType<PartDirective>()
        .any((e) => e.uri.stringValue == part);

/// Returns a URL representing [element].
String urlOfElement(Element element) => element.kind == ElementKind.DYNAMIC
    ? 'dart:core#dynamic'
    : element.kind == ElementKind.NEVER
        ? 'dart:core#Never'
        // using librarySource.uri – in case the element is in a part
        : normalizeUrl(element.librarySource!.uri)
            .replace(fragment: element.name)
            .toString();

Uri normalizeUrl(Uri url) {
  switch (url.scheme) {
    case 'dart':
      return _normalizeDartUrl(url);
    case 'package':
      return packageToAssetUrl(url);
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
    // TODO is it safe to use empty url?
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
Uri packageToAssetUrl(Uri url) => url.scheme == 'package'
    ? url.replace(
        scheme: 'asset',
        pathSegments: <String>[
          url.pathSegments.first,
          'lib',
          ...url.pathSegments.skip(1),
        ],
      )
    : url;

/// Returns a `asset:` URL converted to a `package:` URL.
///
/// For example, this transformers `asset:source_gen/lib/source_gen.dart' into:
/// `package:source_gen/source_gen.dart`. Asset URLs that aren't pointing to a
/// file in the 'lib' folder are not modified.
///
/// Asset URLs come from `package:build`, as they are able to describe URLs that
/// are not describable using `package:...`, such as files in the `bin`, `tool`,
/// `web`, or even root directory of a package - `asset:some_lib/web/main.dart`.
Uri assetToPackageUrl(Uri url) => url.scheme == 'asset' &&
        url.pathSegments.isNotEmpty &&
        url.pathSegments[1] == 'lib'
    ? url.replace(
        scheme: 'package',
        pathSegments: [
          url.pathSegments.first,
          ...url.pathSegments.skip(2),
        ],
      )
    : url;
