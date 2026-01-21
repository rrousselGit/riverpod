import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    return SliverVariableTree(byte: widget.variable);
  }
}

class SliverVariableTree extends ConsumerStatefulWidget {
  const SliverVariableTree({super.key, required this.byte});

  final Byte<VariableRef> byte;

  @override
  ConsumerState<SliverVariableTree> createState() => _SliverVariableTreeState();
}

class _Node {
  _Node({required this.byte, this.isOpen = false, required this.subscription});

  final Byte<VariableRef> byte;
  final ProviderSubscription<void> subscription;
  Byte<ResolvedVariable>? resolvedVariable;
  bool isOpen;
}

class _SliverVariableTreeState extends ConsumerState<SliverVariableTree> {
  final paths = <_Node>[];

  @override
  void initState() {
    late final ProviderSubscription<void> root;
    root = ref.listenManual(
      _resolvedVariableForRef(widget.byte),
      (_, next) => _handleNodeChange(widget.byte, next),
      fireImmediately: true,
    );
  }

  void _handleNodeChange(
    Byte<VariableRef> ref,
    Byte<ResolvedVariable> variable,
  ) {
    final index = paths.indexWhere((node) => node.byte == ref);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: paths.length,
      itemBuilder: (context, index) {
        final node = paths.entries.elementAt(index);
      },
    );
  }
}

final class _VariableId {
  _VariableId({required this.variable});
  final VariableRef variable;
}

sealed class _VariablePath {}

final _resolvedVariableForRef =
    FutureProvider.family<Byte<ResolvedVariable>, Byte<VariableRef>>(
      name: '_variableInspectorProvider',
      (ref, id) async {
        // final eval = ref.watch(evalProvider());

        return ByteVariable(const NullVariableRef());
      },
    );

class _VariableTreeView extends ConsumerWidget {
  const _VariableTreeView({super.key, required this.byte});

  final Byte<ResolvedVariable> byte;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Text('Variable Tree View'),
    );
  }
}
