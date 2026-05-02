import 'dart:collection';

import 'package:flutter/material.dart';

@immutable
abstract class Node<NodeT extends Node<NodeT>> {
  List<NodeT> get children;

  void onRemove() {}
}

class TreeListEntry<NodeT extends Node<NodeT>> {
  TreeListEntry._({required this.node});

  final NodeT node;
  late int length;
}

extension type TreeList<NodeT extends Node<NodeT>>._(
  List<TreeListEntry<NodeT>> _innerList
) {
  TreeList() : this._([]);

  int get length => _innerList.length;
  bool get isEmpty => _innerList.isEmpty;

  @visibleForTesting
  List<TreeListEntry<NodeT>> get debugEntries =>
      UnmodifiableListView(_innerList);

  Iterable<TreeListEntry<NodeT>> _toExpanded(NodeT node) sync* {
    var length = 1;
    final entry = TreeListEntry._(node: node);
    yield entry;

    for (final directChild in node.children) {
      for (final item in _toExpanded(directChild)) {
        yield item;
        length++;
      }
    }

    entry.length = length;
  }

  void _callRemove(int start, int end) {
    for (var i = start; i < end; i++) {
      final entry = _innerList[i];
      entry.node.onRemove();
    }
  }

  void _propagateLengthDelta(int startIndex, int delta) {
    if (delta == 0) return;

    for (var i = startIndex - 1; i >= 0; i--) {
      final entry = _innerList[i];
      if (startIndex < i + entry.length) {
        entry.length += delta;
      }
    }
  }

  int? indexWhere(bool Function(NodeT node) test) {
    final index = _innerList.indexWhere((entry) => test(entry.node));

    return index == -1 ? null : index;
  }

  void removeAt(int index) {
    final entry = _innerList.elementAtOrNull(index);
    if (entry == null) return;
    final removedLength = entry.length;

    _callRemove(index, index + removedLength);
    _innerList.removeRange(index, index + removedLength);
    _propagateLengthDelta(index, -removedLength);
  }

  void add(NodeT value) {
    _innerList.addAll(_toExpanded(value));
  }

  NodeT operator [](int index) => _innerList[index].node;

  void operator []=(int index, NodeT value) {
    final previous = _innerList.elementAtOrNull(index);
    final end = index + (previous?.length ?? 1);
    final expanded = _toExpanded(value).toList();
    final newExpandedLength = expanded.length;
    final delta = newExpandedLength - (previous?.length ?? 1);

    _callRemove(index, end);

    _innerList.replaceRange(index, end, expanded);
    _propagateLengthDelta(index, delta);
  }
}
