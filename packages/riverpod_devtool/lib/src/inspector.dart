import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'vm_service.dart';

class Inspector extends ConsumerStatefulWidget {
  const Inspector({super.key, required this.variable});

  final Byte variable;

  @override
  ConsumerState<Inspector> createState() => _InspectorState();
}

class _InspectorState extends ConsumerState<Inspector> {
  @override
  Widget build(BuildContext context) {
    return VariableInspector(byte: widget.variable);
  }
}

class VariableInspector extends StatelessWidget {
  const VariableInspector({super.key, required this.byte});

  final Byte byte;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: _VariableTreeView(byte: byte));
  }
}

final class _VariableId {
  _VariableId({required this.variable});
  final VariableRef variable;
}

sealed class _VariablePath {}

final _variableInspectorProvider =
    FutureProvider.family<ResolvedVariable, _VariableId>(
      name: '_variableInspectorProvider',
      (ref, id) {
        final ref = id.variable;

        return NullVariable();
      },
    );

class _VariableTreeView extends ConsumerWidget {
  const _VariableTreeView({super.key, required this.byte});

  final Byte byte;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Text('Variable Tree View'),
    );
  }
}
