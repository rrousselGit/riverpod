import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:vm_service/vm_service.dart';

import '../tree_list.dart';
import '../vm_service.dart';

class Inspector extends ConsumerStatefulWidget {
  const Inspector({super.key, required this.object});

  final RootCachedObject object;

  @override
  ConsumerState<Inspector> createState() => _InspectorState();
}

class _InspectorState extends ConsumerState<Inspector> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [SliverVariableTree(object: widget.object)],
    );
  }
}

sealed class _VariableNode extends Node<_VariableNode> {
  _VariableNode({required this.children, required this.level});

  final int level;
  @override
  final List<_VariableNode> children;
}

final class _CachedObjectNode extends _VariableNode {
  _CachedObjectNode({
    required this.object,
    required this.variable,
    required super.children,
    required super.level,
  });

  final CachedObject object;
  final Byte<ResolvedVariable>? variable;
}

final class _ClosingNode extends _VariableNode {
  _ClosingNode({required this.symbol, required super.level})
    : super(children: const []);

  final String symbol;
}

final _openedVariableNodesProvider =
    NotifierProvider<_OpenedVariableNodes<CachedObject>, Set<CachedObject>>(
      _OpenedVariableNodes.new,
    );

class _OpenedVariableNodes<T> extends Notifier<Set<T>> {
  @override
  Set<T> build() => {};

  void toggle(T byte) {
    if (state.contains(byte)) {
      state = {...state}..remove(byte);
    } else {
      state = {...state}..add(byte);
    }
  }

  void remove(T byte) {
    // We're only cleaning memory. No need to notify listeners.
    state.remove(byte);
  }
}

_ClosingNode? _resolveClosingNode(
  Byte<ResolvedVariable>? variable,
  bool isOpen,
  int level,
) {
  switch (variable) {
    case _ when !isOpen:
    case null:
    case ByteError<ResolvedVariable>():
      return null;
    case ByteVariable<ResolvedVariable>(:final instance):
      switch (instance) {
        case ListVariable():
          return _ClosingNode(symbol: ']', level: level);
        case SetVariable():
          return _ClosingNode(symbol: '}', level: level);
        case UnknownObjectVariable():
        case NullVariable():
        case BoolVariable():
        case StringVariable():
        case IntVariable():
        case DoubleVariable():
        case TypeVariable():
        case RecordVariable():
          return null;
      }
  }
}

final ProviderFamily<_VariableNode, (CachedObject, int level)>
_variableNodeForObjectProvider = .new(
  name: '_variableNodeForByte',
  isAutoDispose: true,
  (ref, args) {
    final (object, level) = args;

    final variable = ref.watch(_resolvedVariableForObject(object)).value;
    final isOpen = ref.watch(
      _openedVariableNodesProvider.select((nodes) => nodes.contains(object)),
    );

    final closingNode = _resolveClosingNode(variable, isOpen, level);

    List<_VariableNode> children;
    switch (variable) {
      case null || ByteError<ResolvedVariable>():
      case _ when !isOpen:
        children = const <_VariableNode>[];
      case ByteVariable<ResolvedVariable>(:final instance):
        final _children = instance.children.map((child) {
          final childNode = ref.watch(
            _variableNodeForObjectProvider((child, level + 1)),
          );

          switch (childNode) {
            case _CachedObjectNode(variable: == null):
              return null;
            case _ClosingNode():
            case _CachedObjectNode():
              return childNode;
          }
        }).toList();
        children = _children.nonNulls.toList();

        // Wait for all children to be resolved before we show any.
        // This avoids flickering when opening nodes
        if (children.length != instance.children.length) {
          children = const [];
        }

        if (children.isNotEmpty && closingNode != null) {
          children.add(closingNode);
        }
    }

    return _CachedObjectNode(
      object: object,
      variable: variable,
      children: children,
      level: level,
    );
  },
);

class SliverVariableTree extends ConsumerStatefulWidget {
  const SliverVariableTree({
    super.key,
    required this.object,
    this.reversed = false,
  });

  final RootCachedObject object;
  final bool reversed;

  @override
  ConsumerState<SliverVariableTree> createState() => _SliverVariableTreeState();
}

class _SliverVariableTreeState extends ConsumerState<SliverVariableTree> {
  late final notifier = ref.listenManual(
    _openedVariableNodesProvider,
    (_, _) {},
  );

  final _disposable = Disposable();
  late final nodes = TreeList<_VariableNode>();
  ProviderSubscription<_VariableNode>? sub;

  void _listen(RootCachedObject byte) {
    assert(sub == null, 'Listener already exists for $byte');

    sub = ref.listenManual(
      _variableNodeForObjectProvider((byte, 0)),
      fireImmediately: true,
      (_, resolvedVariableByte) {
        late final indexForNode = nodes.indexWhere(
          (n) => n is _CachedObjectNode && n.object == byte,
        );

        setState(() {
          if (indexForNode != null) {
            nodes[indexForNode] = resolvedVariableByte;
          } else {
            nodes.add(resolvedVariableByte);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _disposable.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _listen(widget.object);
  }

  void _removeListener(RootCachedObject byte) {
    if (nodes.isEmpty) return;

    assert(
      nodes[0] is _CachedObjectNode &&
          (nodes[0] as _CachedObjectNode).object == byte,
      'Bad state: ${(nodes[0] as _CachedObjectNode).object} != $byte',
    );
    nodes.removeAt(0);
    sub?.close();
    sub = null;

    assert(nodes.isEmpty, 'Nodes should be empty after clear');
  }

  @override
  void didUpdateWidget(covariant SliverVariableTree oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.object != widget.object) {
      _removeListener(oldWidget.object);
      _listen(widget.object);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return Consumer(
          builder: (context, ref, child) {
            final node = widget.reversed
                ? nodes[nodes.length - 1 - index]
                : nodes[index];

            final padding =
                const EdgeInsets.symmetric(horizontal: 12) +
                EdgeInsets.only(left: 20.0 * node.level);

            final openNotifier = ref.watch(
              _openedVariableNodesProvider.notifier,
            );

            return Padding(
              padding: padding,
              child: switch (node) {
                _ClosingNode(:final symbol) => Text(symbol),
                // TODO remove Container()
                _CachedObjectNode(variable: null) => Container(),
                _CachedObjectNode(:final variable?) => _ByteTile(
                  byte: variable,
                  shouldShowExpansible: true,
                  label: node.object.label,
                  isOpen: ref.watch(
                    _openedVariableNodesProvider.select(
                      (nodes) => nodes.contains(node.object),
                    ),
                  ),
                  open: () => openNotifier.toggle(node.object),
                ),
              },
            );
          },
        );
      },
    );
  }
}

typedef Initialize = void Function();

class _ByteTile extends StatelessWidget {
  const _ByteTile({
    super.key,
    required this.byte,
    required this.isOpen,
    required this.open,
    required this.label,
    required this.shouldShowExpansible,
  });

  final Byte<ResolvedVariable> byte;
  final String? label;
  final bool isOpen;
  final void Function() open;
  final bool shouldShowExpansible;

  @override
  Widget build(BuildContext context) {
    return switch (byte) {
      ByteError(:final error) => ByteErrorTile(error: error, label: label),
      ByteVariable(:final instance) => _ResolvedVariableTile(
        variable: instance,
        isOpen: isOpen,
        open: open,
        label: label,
        shouldShowExpansible: shouldShowExpansible,
      ),
    };
  }
}

class ByteErrorTile extends StatelessWidget {
  const ByteErrorTile({super.key, required this.error, required this.label});

  final ByteErrorType error;
  final String? label;

  @override
  Widget build(BuildContext context) {
    switch (error) {
      case SentinelExceptionType(
        error: Sentinel(kind: SentinelKind.kNotInitialized),
      ):
        return Text.rich(
          TextSpan(
            children: [
              if (label != null) TextSpan(text: '$label: '),
              const TextSpan(
                // TODO add a mean to init the variable
                text: '<not initialized>',
                style: TextStyle(color: _NodeTileTheme.evalErrorColor),
              ),
            ],
          ),
        );
      case final error:
        return Text.rich(
          TextSpan(
            text: error.toString(),
            style: const TextStyle(color: _NodeTileTheme.evalErrorColor),
          ),
        );
    }
  }
}

class _ResolvedVariableTile extends StatelessWidget {
  const _ResolvedVariableTile({
    super.key,
    required this.variable,
    required this.isOpen,
    required this.open,
    required this.label,
    required this.shouldShowExpansible,
  });

  final ResolvedVariable variable;
  final String? label;
  final bool isOpen;
  final void Function() open;
  final bool shouldShowExpansible;

  @override
  Widget build(BuildContext context) {
    final variable = this.variable;

    Widget content;

    switch (variable) {
      case NullVariable():
        content = const Text(
          'null',
          style: TextStyle(color: _NodeTileTheme.nullColor),
        );
      case BoolVariable(:final Object value):
        content = Text(
          '$value',
          style: const TextStyle(color: _NodeTileTheme.boolColor),
        );
      case StringVariable(:final value):
        content = Text(
          '"${value.escape('"')}"',
          style: const TextStyle(color: _NodeTileTheme.stringColor),
        );
      case IntVariable(:final num value) || DoubleVariable(:final num value):
        content = Text(
          '$value',
          style: const TextStyle(color: _NodeTileTheme.numColor),
        );

      case TypeVariable(:final name):
        content = Text(
          name,
          style: const TextStyle(color: _NodeTileTheme.typeColor),
        );

      case ListVariable(:final children):
        content = Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '['),
              TextSpan(
                text: ' length=${children.length} ',
                style: const TextStyle(color: _NodeTileTheme.hashColor),
              ),
              if (!isOpen) const TextSpan(text: ']'),
            ],
          ),
        );

      case SetVariable(:final children):
        content = Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '{'),
              TextSpan(
                text: ' length=${children.length} ',
                style: const TextStyle(color: _NodeTileTheme.hashColor),
              ),
              if (!isOpen) const TextSpan(text: '}'),
            ],
          ),
        );

      case UnknownObjectVariable(:final type):
        content = Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$type ',
                style: const TextStyle(color: _NodeTileTheme.typeColor),
              ),
              if (variable.identityHashCode case final hash?)
                TextSpan(
                  text: '#${hash.toRadixString(16)}',
                  style: const TextStyle(color: _NodeTileTheme.hashColor),
                ),
            ],
          ),
        );

      case RecordVariable():
        content = const Text(
          'Record',
          style: TextStyle(color: _NodeTileTheme.typeColor),
        );
    }

    if (label case final label?) {
      content = Row(
        children: [
          Text('$label: '),
          Expanded(child: content),
        ],
      );
    }

    if (variable.children.isEmpty || !shouldShowExpansible) return content;

    return _ExpansibleTile(
      isExpanded: isOpen,
      onPressed: open,
      child: InkWell(onTap: open, child: content),
    );
  }
}

class _ExpansibleTile extends StatelessWidget {
  const _ExpansibleTile({
    super.key,
    required this.isExpanded,
    required this.onPressed,
    required this.child,
  });

  final bool isExpanded;
  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = DefaultTextStyle.of(context).style.fontSize ?? 14.0;

    final icon = isExpanded ? Icons.expand_more : Icons.chevron_right;

    return Row(
      children: [
        Text.rich(
          TextSpan(
            text: String.fromCharCode(icon.codePoint),
            recognizer: TapGestureRecognizer()..onTap = onPressed,
            style: TextStyle(
              fontFamily: icon.fontFamily,
              package: icon.fontPackage,
              fontSize: size,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _NodeTileTheme {
  static const typeColor = Color.fromARGB(255, 78, 201, 176);
  static const boolColor = Color.fromARGB(255, 86, 156, 214);
  static const nullColor = boolColor;
  static const numColor = Color.fromARGB(255, 181, 206, 168);
  static const stringColor = Color.fromARGB(255, 206, 145, 120);
  static const hashColor = Color.fromARGB(255, 128, 128, 128);
  static const evalErrorColor = Color.fromARGB(255, 128, 128, 128);
}

extension on String {
  String escape(String char) => replaceAll(char, '\\$char');
}

final _resolvedVariableForObject = FutureProvider.autoDispose
    .family<Byte<ResolvedVariable>, CachedObject>(
      name: '_variableInspectorProvider',
      (ref, object) async {
        final eval = await ref.watch(evalProvider.future);

        final byte = await object.read(eval, isAlive: ref.disposable());

        switch (byte) {
          case ByteError():
            return ByteError(byte.error);
          case ByteVariable():
            return ByteVariable(
              ResolvedVariable.fromInstance(object, byte.instance),
            );
        }
      },
    );
