import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:stack_trace/stack_trace.dart';

import 'frames.dart';
import 'providers.dart';
import 'search.dart';
import 'ui.dart';
import 'vm_service.dart';

class FrameView extends HookConsumerWidget {
  const FrameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrameIndex = useState<int?>(null);

    final selectedFrame = ref.watch(
      framesProvider.select(
        (frames) => selectedFrameIndex.value == null
            ? frames.value?.lastOrNull
            : frames.value?.elementAtOrNull(selectedFrameIndex.value!),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _FramePanel(selectedFrame: selectedFrame)),
        Center(
          child: FrameStepper(
            selectedFrameIndex: selectedFrame?.frame.index,
            onSelect: (index) => selectedFrameIndex.value = index,
          ),
        ),
      ],
    );
  }
}

class _FramePanel extends ConsumerWidget {
  const _FramePanel({super.key, required this.selectedFrame});

  final FoldedFrame? selectedFrame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedFrame case final selectedFrame?) {
      return _FrameViewer(frame: selectedFrame);
    }

    return const Panel(child: Center(child: Text('No frame selected')));
  }
}

class _FrameViewer extends HookConsumerWidget {
  const _FrameViewer({super.key, required this.frame});

  final FoldedFrame frame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = useState<internals.ElementId?>(null);
    final searchController = useTextEditingController();
    final search = useValueListenable(searchController);

    final originStates = ref.watch(
      filteredProvidersProvider((text: search.text, frame: frame)),
    );

    final selected =
        originStates.values
            .expand((e) => e)
            .where((e) => e.isSelected(selectedId.value))
            .firstOrNull ??
        originStates.values.expand((e) => e).firstOrNull;

    return SplitPane(
      axis: Axis.horizontal,
      initialFractions: const [0.3, 0.7],
      children: [
        _ProviderPickerPanel(
          searchController: searchController,
          originStates: originStates,
          selectedId: selected?.element.provider.elementId,
          onSelected: (value) async {
            if (value?.origin.creationStackTrace case final trace?) {
              await openTraceInIDE(ref, Trace.parse(trace));
            }

            selectedId.value = value?.elementId;
          },
        ),

        if (selected case final selected?)
          Panel(
            child: _StateView(meta: selected.element.provider, frame: frame),
          )
        else
          const Panel(child: Text('No provider selected')),
      ],
    );
  }
}

Future<void> openTraceInIDE(MutationTarget target, Trace trace) async {
  const _riverpodPackages = {
    'riverpod',
    'hooks_riverpod',
    'flutter_riverpod',
    'riverpod_generator',
  };

  final mutation = Mutation<void>();
  await mutation.run(target, (tsx) async {
    final eval = await tsx.get(riverpodFrameworkEvalProvider.future);

    final firstNonRiverpodFrame = trace.frames
        .where((frame) => !_riverpodPackages.contains(frame.package))
        .firstOrNull;
    if (firstNonRiverpodFrame == null) return;

    await eval.evalInstance(isAlive: Disposable(), '''
        openInIDE(
          uri: '${firstNonRiverpodFrame.uri}',
          line: ${firstNonRiverpodFrame.line},
          column: ${firstNonRiverpodFrame.column}
        )
      ''');
  });
}

class _StateView extends StatelessWidget {
  const _StateView({super.key, required this.meta, required this.frame});

  final ProviderMeta meta;
  final FoldedFrame frame;

  @override
  Widget build(BuildContext context) {
    // final state = frame.state.providers[meta.elementId];

    return Column(children: [Text('${ /*state?.state ??*/ '<...>'}')]);
  }
}

class _ProviderPickerPanel extends HookConsumerWidget {
  const _ProviderPickerPanel({
    super.key,
    required this.selectedId,
    required this.onSelected,
    required this.originStates,
    required this.searchController,
  });

  final OriginStates originStates;
  final internals.ElementId? selectedId;
  final void Function(ProviderMeta?) onSelected;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Panel(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DevtoolSearchBar(
              hintText: 'Search Providers',
              controller: searchController,
            ),
          ),
          const Divider(),
          for (final associatedProviders in originStates.values) ...[
            if (associatedProviders.length == 1)
              _Tile(
                onTap: () {
                  onSelected(associatedProviders.single.element.provider);
                },
                selected:
                    associatedProviders.length == 1 &&
                    associatedProviders.single.isSelected(selectedId),
                hash: associatedProviders.single.origin.hashValue,
                creationStackTrace: associatedProviders
                    .single
                    .element
                    .provider
                    .creationStackTrace,
                containerHash: associatedProviders
                    .single
                    .element
                    .provider
                    .containerHashValue,
                associatedProviders.single.match,
              ),
            // else
            //   _Heading(meta.value.toStringValue),

            // if (associatedProviders.length > 1) ...[
            //   for (final (index, providerState) in associatedProviders.indexed)
            //     if (index == associatedProviders.length - 1)
            //       _Tile(
            //         onTap: () => onSelected(providerState),
            //         selected: providerState.isSelected(selectedId),
            //         hash: providerState.hashValue,
            //         creationStackTrace: providerState.creationStackTrace,
            //         containerHash: providerState.containerHashValue,
            //         '└─ ${providerState.toStringValue}',
            //       )
            //     else
            //       _Tile(
            //         onTap: () => onSelected(providerState),
            //         selected: providerState.isSelected(selectedId),
            //         hash: providerState.hashValue,
            //         creationStackTrace: providerState.creationStackTrace,
            //         containerHash: providerState.containerHashValue,
            //         '├─ ${providerState.toStringValue}',
            //       ),
            // ],
          ],
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(text),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
    this.text, {
    super.key,
    this.selected = false,
    required this.onTap,
    required this.hash,
    required this.containerHash,
    required this.creationStackTrace,
  });

  final FuzzyMatch text;
  final bool selected;
  final void Function()? onTap;
  final String hash;
  final String containerHash;
  final String? creationStackTrace;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Tooltip(
        message: creationStackTrace ?? 'Default tooltip',
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FuzzyText(match: text),
          ),
        ),
      ),
    );
  }
}
