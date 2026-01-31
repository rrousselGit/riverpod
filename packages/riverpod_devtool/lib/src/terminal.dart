import 'package:devtools_app_shared/ui.dart' as ui;
import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vm_service/vm_service.dart';

import 'state_inspector/inspector.dart';
import 'ui_primitives/panel.dart';
import 'vm_service.dart';

final _eval = Mutation<void>();

class Terminal extends ConsumerStatefulWidget {
  const Terminal({super.key, required this.state});

  final RootCachedObject state;

  @override
  ConsumerState<Terminal> createState() => _TerminalState();
}

class _TerminalState extends ConsumerState<Terminal> {
  final List<({String code, Byte<RootCachedObject> byte})> history = [];

  final _disposable = Disposable();

  @override
  void dispose() {
    _disposable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
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
                            initialize: () {
                              // TODO implement initialization. Share with other locations
                            },
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
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ui.DevToolsClearableTextField(
                hintText: r'$notifier.state = 21',
                labelText: 'Terminal',
                onSubmitted: (code) {
                  final trim = code.trim();
                  if (trim.isEmpty) return;

                  _eval.run(ref, (tsx) async {
                    // TODO use library from selected provider
                    final evalFactory = await tsx.get(evalProvider.future);

                    Byte<RootCachedObject> result;
                    final state = await widget.state.readRef(
                      evalFactory,
                      _disposable,
                    );
                    switch (state) {
                      case ByteError(:final error):
                        result = ByteError(error);
                        return;
                      case ByteVariable():
                        break;
                    }

                    final eval =
                        evalFactory.forRef(state.instance) ??
                        evalFactory.dartCore;

                    result = await RootCachedObject.create(
                      code,
                      eval,
                      isAlive: _disposable,
                      // TODO scope to expose $notifier and $state
                      // TODO maybe support $previous to refer to the last terminal result
                      scope: {r'$state': ?state.instance.id},
                    );

                    setState(
                      () => history.insert(0, (code: trim, byte: result)),
                    );
                  });
                },
                additionalSuffixActions: const [_TerminalHelp()],
              ),
            ),
          ],
        ),
      ),
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
                ': direct state access\n\n'
                'Only types/variables that are accessible to the Notifier/Provider can be used here.',
          ),
        ],
      ),
      child: Icon(Icons.help),
    );
  }
}
