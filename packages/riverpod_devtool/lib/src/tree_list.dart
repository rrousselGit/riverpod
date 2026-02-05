import 'dart:collection';

import 'package:flutter/material.dart';

@immutable
abstract class Node<NodeT extends Node<NodeT>> {
  List<NodeT> get children;

  void onRemove() {}
}

class _NodeEntry<NodeT extends Node<NodeT>> {
  _NodeEntry({required this.node});

  final NodeT node;
  late final int length;
}

extension type TreeList<NodeT extends Node<NodeT>>._(
  List<_NodeEntry<NodeT>> _innerList
) {
  TreeList() : this._([]);

  int get length => _innerList.length;
  bool get isEmpty => _innerList.isEmpty;

  Iterable<_NodeEntry<NodeT>> _toExpanded(NodeT node) sync* {
    var length = 1;
    final entry = _NodeEntry(node: node);
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

  int? indexWhere(bool Function(NodeT node) test) {
    final index = _innerList.indexWhere((entry) => test(entry.node));

    return index == -1 ? null : index;
  }

  void removeAt(int index) {
    final entry = _innerList.elementAtOrNull(index);
    if (entry == null) return;

    _callRemove(index, index + entry.length);
    _innerList.removeRange(index, index + entry.length);
  }

  void add(NodeT value) {
    _innerList.addAll(_toExpanded(value));
  }

  NodeT operator [](int index) => _innerList[index].node;

  void operator []=(int index, NodeT value) {
    final previous = _innerList.elementAtOrNull(index);
    final end = index + (previous?.length ?? 1);

    _callRemove(index, end);

    _innerList.replaceRange(index, end, _toExpanded(value));
  }
}
