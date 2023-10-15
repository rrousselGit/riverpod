// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// A delegate that allows using ListView with an undetermined list length
/// while preserve the "build only what is visible" behaviour.
class SliverIterableChildDelegate extends SliverChildDelegate {
  SliverIterableChildDelegate(
    this.children, {
    this.estimatedChildCount,
  });

  final Iterable<Widget?> children;
  int? _lastAccessedIndex;
  late Iterator<Widget?> _lastAccessedIterator;

  @override
  Widget? build(BuildContext context, int index) {
    if (_lastAccessedIndex == null || _lastAccessedIndex! > index) {
      _lastAccessedIndex = -1;
      _lastAccessedIterator = children.iterator;
    }

    while (_lastAccessedIndex! < index) {
      _lastAccessedIterator.moveNext();
      _lastAccessedIndex = _lastAccessedIndex! + 1;
    }

    return _lastAccessedIterator.current;
  }

  @override
  final int? estimatedChildCount;

  @override
  bool shouldRebuild(SliverIterableChildDelegate oldDelegate) {
    return children != oldDelegate.children ||
        _lastAccessedIndex != oldDelegate._lastAccessedIndex ||
        _lastAccessedIterator != oldDelegate._lastAccessedIterator;
  }
}
