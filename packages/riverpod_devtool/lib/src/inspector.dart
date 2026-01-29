import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:vm_service/vm_service.dart';

import 'ide.dart';
import 'tree_list.dart';
import 'vm_service.dart';

class Inspector extends ConsumerStatefulWidget {
  const Inspector({super.key, required this.variable});

  final Byte<VariableRef> variable;

  @override
  ConsumerState<Inspector> createState() => _InspectorState();
}

class _InspectorState extends ConsumerState<Inspector> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [SliverVariableTree(byte: widget.variable)],
    );
  }
}

sealed class _VariableNode extends Node<_VariableNode> {
  _VariableNode({
    required this.variable,
    required this.children,
    required this.level,
  });

  final Byte<ResolvedVariable>? variable;
  final int level;
  @override
  final List<_VariableNode> children;
}

final class _ByteNode extends _VariableNode {
  _ByteNode({
    required this.byte,
    required super.variable,
    required super.children,
    required super.level,
  });

  final Byte<VariableRef> byte;
}

final class _ClosingNode extends _VariableNode {
  _ClosingNode({
    required this.symbol,
    required super.variable,
    required super.level,
  }) : super(children: const []);

  final String symbol;
}

final _openedVariableNodesProvider = NotifierProvider(_OpenedVariableNodes.new);

class _OpenedVariableNodes extends Notifier<Set<Byte<VariableRef>>> {
  @override
  Set<Byte<VariableRef>> build() => {};

  void toggle(Byte<VariableRef> byte) {
    if (state.contains(byte)) {
      state = {...state}..remove(byte);
    } else {
      state = {...state}..add(byte);
    }
  }

  void remove(Byte<VariableRef> byte) {
    // We're only cleaning memory. No need to notify listeners.
    // TODO
    // state.remove(byte);
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
    case ByteSentinel<ResolvedVariable>():
      return null;
    case ByteVariable<ResolvedVariable>(:final instance):
      switch (instance) {
        case FieldVariable():
          return _resolveClosingNode(instance.value, isOpen, level);
        case ListVariable():
          return _ClosingNode(symbol: ']', variable: variable, level: level);
        case SetVariable():
          return _ClosingNode(symbol: '}', variable: variable, level: level);
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

final ProviderFamily<_VariableNode, (Byte<VariableRef>, int level)>
_variableNodeForByteProvider = .new(
  name: '_variableNodeForByte',
  isAutoDispose: true,
  (ref, args) {
    final (byte, level) = args;

    final variable = ref.watch(_resolvedVariableForRef(byte)).value;
    final isOpen = ref.watch(
      _openedVariableNodesProvider.select((nodes) => nodes.contains(byte)),
    );

    final closingNode = _resolveClosingNode(variable, isOpen, level);

    List<_VariableNode> children;
    switch (variable) {
      case null || ByteSentinel<ResolvedVariable>():
      case _ when !isOpen:
        children = const <_VariableNode>[];
      case ByteVariable<ResolvedVariable>(:final instance):
        children = instance.children
            .map((child) {
              final childNode = ref.watch(
                _variableNodeForByteProvider((child, level + 1)),
              );

              switch (childNode) {
                case _ByteNode(variable: == null):
                  return null;
                case _ClosingNode():
                case _ByteNode():
                  return childNode;
              }
            })
            .nonNulls
            .toList();

        // Wait for all children to be resolved before we show any.
        // This avoids flickering when opening nodes
        if (children.length != instance.children.length) children = const [];

        if (children.isNotEmpty && closingNode != null) {
          children.add(closingNode);
        }
    }

    return _ByteNode(
      byte: byte,
      variable: variable,
      children: children,
      level: level,
    );
  },
);

class SliverVariableTree extends ConsumerStatefulWidget {
  const SliverVariableTree({super.key, required this.byte});

  final Byte<VariableRef> byte;

  @override
  ConsumerState<SliverVariableTree> createState() => _SliverVariableTreeState();
}

class _SliverVariableTreeState extends ConsumerState<SliverVariableTree> {
  late final notifier = ref.listenManual(
    _openedVariableNodesProvider,
    (_, _) {},
  );

  late final nodes = TreeList<_VariableNode>();
  ProviderSubscription<_VariableNode>? sub;

  void _listen(Byte<VariableRef> byte) {
    assert(sub == null, 'Listener already exists for $byte');

    sub = ref.listenManual(
      _variableNodeForByteProvider((byte, 0)),
      fireImmediately: true,
      (_, resolvedVariableByte) {
        late final indexForNode = nodes.indexWhere(
          (n) => n is _ByteNode && n.byte == byte,
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
  void initState() {
    super.initState();

    _listen(widget.byte);
  }

  void _removeListener(Byte<VariableRef> byte) {
    if (nodes.isEmpty) return;

    assert(
      nodes[0] is _ByteNode && (nodes[0] as _ByteNode).byte == byte,
      'Bad state: ${(nodes[0] as _ByteNode).byte} != $byte',
    );
    nodes.removeAt(0);
    sub?.close();
    sub = null;

    assert(nodes.isEmpty, 'Nodes should be empty after clear');
  }

  @override
  void didUpdateWidget(covariant SliverVariableTree oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.byte != widget.byte) {
      _removeListener(oldWidget.byte);
      _listen(widget.byte);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return Consumer(
          builder: (context, ref, child) {
            final node = nodes[index];

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
                // TODO
                _ByteNode(variable: null) => Container(),
                _ByteNode(:final variable?) => _ByteTile(
                  byte: variable,
                  shouldShowExpansible: true,
                  isOpen: ref.watch(
                    _openedVariableNodesProvider.select(
                      (nodes) => nodes.contains(node.byte),
                    ),
                  ),
                  initialize: () {
                    // TODO

                    final value = node.variable?.valueOrNull;
                    if (value == null) return;

                    inspectInIDE(value)?.call(ref);
                  },
                  open: () => openNotifier.toggle(node.byte),
                ),
              },
            );
          },
        );
      },
    );
  }
}

class _ByteTile extends StatelessWidget {
  const _ByteTile({
    super.key,
    required this.byte,
    required this.isOpen,
    required this.open,
    required this.initialize,
    required this.shouldShowExpansible,
  });

  final Byte<ResolvedVariable> byte;
  final bool isOpen;
  final void Function() open;
  final void Function() initialize;
  final bool shouldShowExpansible;

  @override
  Widget build(BuildContext context) {
    return switch (byte) {
      ByteSentinel(sentinel: Sentinel(kind: SentinelKind.kNotInitialized)) =>
        InkWell(
          onTap: initialize,
          child: const Text(
            '<not initialized>',
            style: TextStyle(color: _NodeTileTheme.sentinelColor),
          ),
        ),
      ByteSentinel(:final sentinel) => Text.rich(
        TextSpan(
          text:
              sentinel.valueAsString ??
              '<unknown sentinel error ${sentinel.kind}>',
          style: const TextStyle(color: _NodeTileTheme.sentinelColor),
        ),
      ),
      ByteVariable(:final instance) => _ResolvedVariableTile(
        variable: instance,
        isOpen: isOpen,
        open: open,
        initialize: initialize,
        shouldShowExpansible: shouldShowExpansible,
      ),
    };
  }
}

class _ResolvedVariableTile extends StatelessWidget {
  const _ResolvedVariableTile({
    super.key,
    required this.variable,
    required this.isOpen,
    required this.open,
    required this.initialize,
    required this.shouldShowExpansible,
  });

  final ResolvedVariable variable;
  final bool isOpen;
  final void Function() open;
  final void Function() initialize;
  final bool shouldShowExpansible;

  @override
  Widget build(BuildContext context) {
    final variable = this.variable;

    final Widget content;

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
      case IntVariable(:final Object value) ||
          DoubleVariable(:final Object value):
        content = Text(
          '$value',
          style: const TextStyle(color: _NodeTileTheme.numColor),
        );

      case FieldVariable(key: NamedFieldKey(:final name)):
        content = Row(
          children: [
            Text('$name: '),
            Expanded(
              child: _ByteTile(
                byte: variable.value,
                isOpen: isOpen,
                open: open,
                initialize: initialize,
                shouldShowExpansible: false,
              ),
            ),
          ],
        );
      case FieldVariable(key: PositionalFieldKey()):
        content = _ByteTile(
          byte: variable.value,
          isOpen: isOpen,
          open: open,
          initialize: initialize,
          shouldShowExpansible: false,
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
  static const sentinelColor = Color.fromARGB(255, 128, 128, 128);
}

extension on String {
  String escape(String char) => replaceAll(char, '\\$char');
}

final _resolvedVariableForRef = FutureProvider.autoDispose
    .family<Byte<ResolvedVariable>, Byte<VariableRef>>(
      name: '_variableInspectorProvider',
      (ref, byte) {
        switch (byte) {
          case ByteSentinel<VariableRef>():
            return ByteSentinel<ResolvedVariable>(byte.sentinel);
          case ByteVariable<VariableRef>():
            return byte.instance.resolve(
              (uri) => ref.watch(evalProvider(uri).future),
              ref.disposable(),
            );
        }
      },
    );
