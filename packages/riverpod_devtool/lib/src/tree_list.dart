import 'dart:collection';

import 'package:flutter/material.dart';

@immutable
abstract class Node<T extends Node<T>> {
  List<T> get children;

  void onRemove() {}
}

class _NodeEntry<T extends Node<T>> {
  _NodeEntry({required this.node, required this.length});

  final T node;
  final int Function() length;
}

extension type TreeList<T extends Node<T>>._(List<_NodeEntry<T>> _innerList) {
  TreeList() : this._([]);

  int get length => _innerList.length;
  bool get isEmpty => _innerList.isEmpty;

  Iterable<_NodeEntry<T>> _toExpanded(T node) sync* {
    var length = 1;
    yield _NodeEntry(node: node, length: () => length);

    for (final directChild in node.children) {
      for (final item in _toExpanded(directChild)) {
        yield item;
        length++;
      }
    }
  }

  void _callRemove(int start, int end) {
    for (var i = start; i < end; i++) {
      final entry = _innerList[i];
      entry.node.onRemove();
    }
  }

  int? indexWhere(bool Function(T node) test) {
    final index = _innerList.indexWhere((entry) => test(entry.node));

    return index == -1 ? null : index;
  }

  void removeAt(int index) {
    final entry = _innerList.elementAtOrNull(index);
    if (entry == null) return;

    _callRemove(index, index + entry.length());
    _innerList.removeAt(index);
  }

  void add(T value) {
    _innerList.addAll(_toExpanded(value));
  }

  T operator [](int index) => _innerList[index].node;

  void operator []=(int index, T value) {
    final previous = _innerList.elementAtOrNull(index);
    final end = index + (previous?.length() ?? 1);

    _callRemove(index, end);

    _innerList.replaceRange(index, end, _toExpanded(value));
  }
}
