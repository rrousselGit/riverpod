// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A regular expression that matches against the "size directive" path
/// segment of Google profile image URLs.
///
/// The format is is "`/sNN-c/`", where `NN` is the max width/height of the
/// image, and "`c`" indicates we want the image cropped.
final RegExp sizeDirective = RegExp(r'^s[0-9]{1,5}(-c)?$');

/// Adds [size] (and crop) directive to [photoUrl].
///
/// There are two formats for photoUrls coming from the Sign In backend.
///
/// The two formats can be told apart by the number of path segments in the
/// URL (path segments: parts of the URL separated by slashes "/"):
///
///  * If the URL has 2 or less path segments, it is a *new* style URL.
///  * If the URL has more than 2 path segments, it is an old style URL.
///
/// Old style URLs encode the image transformation directives as the last
/// path segment. Look at the [sizeDirective] Regular Expression for more
/// information about these URLs.
///
/// New style URLs carry the same directives at the end of the URL,
/// after an = sign, like: "`=s120-c-fSoften=1,50,0`".
///
/// Directives may contain the "=" sign (`fSoften=1,50,0`), but it seems the
/// base URL of the images don't. "Everything after the first = sign" is a
/// good heuristic to split new style URLs.
///
/// Each directive is separated from others by dashes. Directives are the same
/// as described in the [sizeDirective] RegExp.
///
/// Modified image URLs are recomposed by performing the parsing steps in reverse.
String addSizeDirectiveToUrl(String photoUrl, double size) {
  final profileUri = Uri.parse(photoUrl);
  final pathSegments = List<String>.from(profileUri.pathSegments);
  if (pathSegments.length <= 2) {
    final imagePath = pathSegments.last;
    // Does this have any existing transformation directives?
    final directiveSeparator = imagePath.indexOf('=');
    if (directiveSeparator >= 0) {
      // Split the baseUrl from the sizing directive by the first "="
      final baseUrl = imagePath.substring(0, directiveSeparator);
      final directive = imagePath.substring(directiveSeparator + 1);
      // Split the directive by "-"
      final directives = Set<String>.from(directive.split('-'))
        // Remove the size directive, if present, and any empty values
        ..removeWhere((s) => s.isEmpty || sizeDirective.hasMatch(s))
        // Add the size and crop directives
        ..addAll(<String>['c', 's${size.round()}']);
      // Recompose the URL by performing the reverse of the parsing
      pathSegments.last = '$baseUrl=${directives.join("-")}';
    } else {
      pathSegments.last = '${pathSegments.last}=c-s${size.round()}';
    }
  } else {
    // Old style URLs
    pathSegments
      ..removeWhere(sizeDirective.hasMatch)
      ..insert(pathSegments.length - 1, 's${size.round()}-c');
  }
  return Uri(
    scheme: profileUri.scheme,
    host: profileUri.host,
    pathSegments: pathSegments,
  ).toString();
}

/// Builds a CircleAvatar profile image of the appropriate resolution
class GoogleUserCircleAvatar extends StatelessWidget {
  /// Creates a new widget based on the specified [identity].
  ///
  /// If [identity] does not contain a `photoUrl` and [placeholderPhotoUrl] is
  /// specified, then the given URL will be used as the user's photo URL. The
  /// URL must be able to handle a [sizeDirective] path segment.
  ///
  /// If [identity] does not contain a `photoUrl` and [placeholderPhotoUrl] is
  /// *not* specified, then the widget will render the user's first initial
  /// in place of a profile photo, or a default profile photo if the user's
  /// identity does not specify a `displayName`.
  const GoogleUserCircleAvatar({
    Key? key,
    required this.identity,
    this.placeholderPhotoUrl,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(key: key);

  /// The Google user's identity; guaranteed to be non-null.
  final User identity;

  /// The color of the text to be displayed if photo is not available.
  ///
  /// If a foreground color is not specified, the theme's text color is used.
  final Color? foregroundColor;

  /// The color with which to fill the circle. Changing the background color
  /// will cause the avatar to animate to the new color.
  ///
  /// If a background color is not specified, the theme's primary color is used.
  final Color? backgroundColor;

  /// The URL of a photo to use if the user's [identity] does not specify a
  /// `photoUrl`.
  ///
  /// If this is `null` and the user's [identity] does not contain a photo URL,
  /// then this widget will attempt to display the user's first initial as
  /// determined from the identity's [User.displayName] field. If that is `null` a
  /// default (generic) Google profile photo will be displayed.
  final String? placeholderPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: LayoutBuilder(builder: _buildClippedImage),
    );
  }

  Widget _buildClippedImage(BuildContext context, BoxConstraints constraints) {
    // Placeholder to use when there is no photo URL, and while the photo is
    // loading. Uses the first character of the display name (if it has one),
    // or the first letter of the email address if it does not.
    final placeholderCharSources = <String?>[
      identity.displayName,
      identity.email,
      '-',
    ];
    final placeholderChar = placeholderCharSources
        .firstWhere((str) => str != null && str.trimLeft().isNotEmpty)!
        .trimLeft()[0]
        .toUpperCase();
    final Widget placeholder = Center(
      child: Text(placeholderChar, textAlign: TextAlign.center),
    );

    final photoUrl = identity.photoURL ?? placeholderPhotoUrl;
    if (photoUrl == null) {
      return placeholder;
    }

    // Add a sizing directive to the profile photo URL.
    final size = MediaQuery.of(context).devicePixelRatio * constraints.maxWidth;
    final sizedPhotoUrl = addSizeDirectiveToUrl(photoUrl, size);

    // Fade the photo in over the top of the placeholder.
    return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Stack(fit: StackFit.expand, children: <Widget>[
            placeholder,
            FadeInImage.memoryNetwork(
              // This creates a transparent placeholder image, so that
              // [placeholder] shows through.
              placeholder: _transparentImage,
              image: sizedPhotoUrl,
            )
          ]),
        ));
  }
}

/// This is an transparent 1x1 gif image.
///
/// Those bytes come from `resources/transparentImage.gif`.
final Uint8List _transparentImage = Uint8List.fromList(
  <int>[
    0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, //
    0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x21, 0xf9, 0x04, 0x01, 0x00, //
    0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, //
    0x00, 0x02, 0x01, 0x44, 0x00, 0x3B
  ],
);
