import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vm_service/vm_service.dart';

import 'state_inspector/inspector.dart';
import 'ui_primitives/borderless_text_field.dart';
import 'vm_service.dart';

final _submit = Mutation<void>();

class Terminal extends ConsumerStatefulWidget {
  const Terminal({super.key, required this.state, required this.notifier});

  final RootCachedObject state;
  final RootCachedObject? notifier;

  @override
  ConsumerState<Terminal> createState() => _TerminalState();
}

class _TerminalState extends ConsumerState<Terminal> {
  final List<({String code, Byte<RootCachedObject> byte})> history = [];

  final _disposable = Disposable();
  late final ProviderSubscription<Future<EvalFactory>> _eval;

  @override
  void initState() {
    super.initState();
    _eval = ref.listenManual(evalProvider.future, (_, _) {});
  }

  @override
  void dispose() {
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
          hintText: r'$notifier.state = 21',
          onSubmitted: (code) {
            final trim = code.trim();
            if (trim.isEmpty) return;

            _submit.run(ref, (tsx) async {
              final evalFactory = await tsx.get(evalProvider.future);

              Byte<RootCachedObject> result;
              final state = await widget.state.readRef(
                evalFactory,
                _disposable,
              );
              final notifier = await widget.notifier?.readRef(
                evalFactory,
                _disposable,
              );

              switch ((state, notifier)) {
                case (ByteError(:final error), _):
                case (_, ByteError(:final error)):
                  result = ByteError(error);
                case (
                  ByteVariable(instance: final state),
                  final ByteVariable<InstanceRef>? notifier,
                ):
                  final eval =
                      evalFactory.forRef(state) ?? evalFactory.dartCore;

                  result = await RootCachedObject.create(
                    code,
                    eval,
                    isAlive: _disposable,
                    // TODO maybe support $previous to refer to the last terminal result
                    scope: {
                      r'$state': ?state.id,
                      r'$notifier': ?notifier?.instance.id,
                    },
                  );
              }

              setState(() => history.insert(0, (code: trim, byte: result)));
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
                ': direct state access\n\n'
                'Only types/variables that are accessible to the Notifier/Provider can be used here.',
          ),
        ],
      ),
      child: Icon(Icons.help),
    );
  }
}
