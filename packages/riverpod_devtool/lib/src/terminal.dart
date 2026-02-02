import 'dart:math' as math;

import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vm_service/vm_service.dart';

import 'object.dart';
import 'state_inspector/inspector.dart';
import 'ui_primitives/borderless_text_field.dart';
import 'vm_service.dart';

final _submit = Mutation<void>();

extension SelectAll on TextEditingController {
  void selectAll() {
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}

class Terminal extends ConsumerStatefulWidget {
  const Terminal({super.key, required this.state, required this.notifier});

  final RootCachedObject state;
  final RootCachedObject? notifier;

  @override
  ConsumerState<Terminal> createState() => _TerminalState();
}

final class _TerminalState extends ConsumerState<Terminal> {
  final List<({String code, Byte<RootCachedObject> byte})> history = [];
  int? _historyIndex;
  final _terminalController = TextEditingController();
  late final _terminalFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      // Up/Down to navigate history

      if (event is! KeyUpEvent) return KeyEventResult.ignored;
      if (event.logicalKey != .arrowDown && event.logicalKey != .arrowUp) {
        return .ignored;
      }

      final index = _historyIndex;
      int? newIndex;
      switch (event.logicalKey) {
        case .arrowDown when index == 0:
          newIndex = null;
        case .arrowDown when index != null && index >= 1:
          newIndex = math.max(index - 1, 0);
        case .arrowUp when index == null && history.isNotEmpty:
          newIndex = 0;
        case .arrowUp when index != null:
          newIndex = math.min(index + 1, history.length - 1);
      }

      if (newIndex != index) {
        _historyIndex = newIndex;

        if (newIndex != null) {
          _terminalController
            ..text = history[newIndex].code
            ..selectAll();
        }
      }

      return KeyEventResult.handled;
    },
  );

  final _disposable = Disposable();
  late final ProviderSubscription<Future<EvalFactory>> _eval;

  @override
  void initState() {
    super.initState();
    _eval = ref.listenManual(evalProvider.future, (_, _) {});
  }

  @override
  void dispose() {
    _terminalFocusNode.dispose();
    _terminalController.dispose();
    final eval = _eval.read();

    // TODO wait for pending requests to complete, to avoid race condition on the delete loop?

    final deleteAll = Future.wait<void>(
      history.map(
        (entry) async =>
            entry.byte.valueOrNull?.delete(await eval, isAlive: _disposable),
      ),
    );

    // Wait after deletion before canceling any pending requests.
    // This avoids cancelling requests before we can remove their cache entries.
    deleteAll.whenComplete(_disposable.dispose);
    super.dispose();
  }

  // 344678928
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CustomScrollView(
              reverse: true,
              slivers: [
                for (final entry in history) ...[
                  switch (entry.byte) {
                    ByteVariable<RootCachedObject>(:final instance) =>
                      SliverVariableTree(object: instance, reversed: true),
                    ByteError<RootCachedObject>(:final error) =>
                      SliverToBoxAdapter(
                        child: ByteErrorTile(
                          error: error,
                          // No label since we're at the root
                          label: null,
                        ),
                      ),
                  },
                  // List is reversed, so we add it after
                  SliverToBoxAdapter(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: r'$ ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(text: entry.code),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        BorderlessTextField(
          controller: _terminalController,
          hintText: r'$notifier.state = 21',
          focusNode: _terminalFocusNode,
          onEditingComplete: () {
            _historyIndex = null;
            final code = _terminalController.text.trim();
            _terminalController.clear();

            if (code.isEmpty) return;

            _submit.run(ref, (tsx) async {
              final evalFactory = await tsx.get(evalProvider.future);

              Byte<RootCachedObject> result;
              final stateFuture = widget.state.readRef(
                evalFactory,
                _disposable,
              );
              final notifierFuture = widget.notifier?.readRef(
                evalFactory,
                _disposable,
              );
              final previousFuture = history.firstOrNull?.byte.let(
                (byte) => byte.valueOrNull?.readRef(evalFactory, _disposable),
              );

              final state = await stateFuture;
              final notifier = await notifierFuture;
              final previous = await previousFuture;

              switch ((state, notifier, previous)) {
                case (ByteError(:final error), _, _):
                case (_, ByteError(:final error), _):
                case (_, _, ByteError(:final error)):
                  result = ByteError(error);
                case (
                  ByteVariable(instance: final state),
                  final ByteVariable<InstanceRef>? notifier,
                  final ByteVariable<InstanceRef>? previous,
                ):
                  final eval =
                      evalFactory.forRef(state) ?? evalFactory.dartCore;

                  result = await RootCachedObject.create(
                    code,
                    eval,
                    isAlive: _disposable,
                    scope: {
                      r'$state': ?state.id,
                      r'$notifier': ?notifier?.instance.id,
                      r'$previous': ?previous?.instance.id,
                    },
                  );
              }

              setState(() => history.insert(0, (code: code, byte: result)));
            });
          },
          prefixIcon: const Icon(Icons.chevron_right),
          additionalSuffixActions: const [_TerminalHelp()],
        ),
      ],
    );
  }
}

class _TerminalHelp extends StatelessWidget {
  const _TerminalHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      richMessage: TextSpan(
        text:
            'Execute Dart code in the context of the selected provider.\n\n'
            'In this context, you get access to:\n'
            '- ',
        children: [
          TextSpan(
            text: r'$notifier',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text:
                ': the associated Notifier, if any\n'
                '- ',
          ),
          TextSpan(
            text: r'$state',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text:
                ': direct state access\n'
                '- ',
          ),
          TextSpan(
            text: r'$previous',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text:
                ': the last value from history\n\n'
                'Only types/variables that are accessible to the Notifier/Provider can be used here.',
          ),
        ],
      ),
      child: Icon(Icons.help),
    );
  }
}
