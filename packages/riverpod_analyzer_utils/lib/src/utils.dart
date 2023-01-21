// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'type_checker.dart';

/// Returns a URL representing [element].
String urlOfElement(Element element) {
  return element.kind == ElementKind.DYNAMIC
      ? 'dart:core#dynamic'
      : element.kind == ElementKind.NEVER
          ? 'dart:core#Never'
          // using librarySource.uri – in case the element is in a part
          : _normalizeUrl(element.librarySource!.uri)
              .replace(fragment: element.name)
              .toString();
}

/// Normalizes an [Uri]
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
Uri _packageToAssetUrl(Uri url) {
  return url.scheme == 'package'
      ? url.replace(
          scheme: 'asset',
          pathSegments: <String>[
            url.pathSegments.first,
            'lib',
            ...url.pathSegments.skip(1),
          ],
        )
      : url;
}
