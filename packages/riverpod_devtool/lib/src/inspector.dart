import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

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
    return SelectableRegion(
      selectionControls: materialTextSelectionControls,
      child: CustomScrollView(
        slivers: [SliverVariableTree(byte: widget.variable)],
      ),
    );
  }
}

class _VariableNode extends Node<_VariableNode> {
  _VariableNode({
    required this.byte,
    required this.variable,
    required this.children,
    required this.level,
  });

  final Byte<VariableRef> byte;
  final Byte<ResolvedVariable>? variable;
  final int level;
  @override
  final List<_VariableNode> children;
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

    final children = switch (variable) {
      null || ByteSentinel<ResolvedVariable>() => const <_VariableNode>[],
      ByteVariable<ResolvedVariable>(:final instance) => [
        for (final child in instance.children)
          if (isOpen)
            ref.watch(_variableNodeForByteProvider((child, level + 1))),
      ],
    };

    return _VariableNode(
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
        late final indexForNode = nodes.indexWhere((n) => n.byte == byte);

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

    assert(nodes[0].byte == byte, 'Bad state: ${nodes[0].byte} != $byte');
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

            final variable = node.variable;

            switch (variable) {
              case null:
                // TODO
                return Container();

              case ByteVariable<ResolvedVariable>():
                final openNotifier = ref.watch(
                  _openedVariableNodesProvider.notifier,
                );
                final isOpen = ref.watch(
                  _openedVariableNodesProvider.select(
                    (nodes) => nodes.contains(node.byte),
                  ),
                );

                Widget child = _NodeText(variable: variable.instance);
                if (variable.instance.children.isNotEmpty) {
                  child = _ExpansibleTile(
                    isExpanded: isOpen,
                    onPressed: () => openNotifier.toggle(node.byte),
                    child: child,
                  );
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12) +
                      EdgeInsets.only(left: 42.0 * node.level),
                  child: child,
                );

              case ByteSentinel<ResolvedVariable>(:final sentinel):
                return Text('Sentinel error ${sentinel.kind}');
            }
          },
        );
      },
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
    return Row(
      children: [
        IconButton(
          icon: Icon(isExpanded ? Icons.expand_more : Icons.chevron_right),
          onPressed: onPressed,
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
  static const labelColor = Color.fromARGB(255, 220, 220, 170);
}

class _NodeText extends StatelessWidget {
  const _NodeText({super.key, required this.variable});

  final ResolvedVariable variable;

  @override
  Widget build(BuildContext context) {
    final variable = this.variable;

    switch (variable) {
      case NullVariable():
        return const Text(
          'null',
          style: TextStyle(color: _NodeTileTheme.nullColor),
        );
      case BoolVariable(:final Object value):
        return Text(
          '$value',
          style: const TextStyle(color: _NodeTileTheme.boolColor),
        );
      case StringVariable(:final Object value):
        return Text(
          '"$value"',
          style: const TextStyle(color: _NodeTileTheme.stringColor),
        );
      case IntVariable(:final Object value):
      case DoubleVariable(:final Object value):
        return Text(
          '$value',
          style: const TextStyle(color: _NodeTileTheme.numColor),
        );
      case FieldVariable():
        return Row(
          children: [
            Text(
              '${variable.name}: ',
              style: const TextStyle(color: _NodeTileTheme.labelColor),
            ),
            Expanded(child: _NodeText(variable: variable.value)),
          ],
        );

      case UnknownObjectVariable(:final type):
        return Row(
          children: [
            Text(type, style: const TextStyle(color: _NodeTileTheme.typeColor)),
            if (variable.identityHashCode case final hash?)
              SelectableRegion(
                selectionControls: materialTextSelectionControls,
                child: Text(
                  '#${hash.toRadixString(16)}',
                  style: const TextStyle(color: _NodeTileTheme.hashColor),
                ),
              ),
          ],
        );
    }
  }
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
