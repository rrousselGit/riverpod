import 'dart:async';

import 'package:devtools_app_shared/ui.dart' as ui;
import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:stack_trace/stack_trace.dart';

import 'frames.dart';
import 'ide.dart';
import 'providers/providers.dart';
import 'search/fuzzy_match.dart';
import 'state_inspector/inspector.dart';
import 'terminal.dart';
import 'ui_primitives/panel.dart';
import 'ui_primitives/search_bar.dart';
import 'vm_service.dart';

class FrameView extends HookConsumerWidget {
  const FrameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrameNotifier = ref.watch(selectedFrameIdProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(child: _FramePanel()),
        Center(
          child: FrameStepper(
            onSelect: (frame) => selectedFrameNotifier.state = frame,
          ),
        ),
      ],
    );
  }
}

class _FramePanel extends ConsumerWidget {
  const _FramePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrame = ref.watch(selectedFrameProvider);

    if (selectedFrame != null) return const _FrameViewer();

    return const Panel(child: Center(child: Text('No frame selected')));
  }
}

class _FrameViewer extends HookConsumerWidget {
  const _FrameViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = useState<internals.ElementId?>(null);
    final searchController = useTextEditingController();
    final search = useValueListenable(searchController);

    final originStates = ref.watch(filteredProvidersProvider(search.text));

    final selected =
        originStates.values
            .expand((e) => e.elements)
            .where((e) => e.isSelected(selectedId.value))
            .firstOrNull ??
        originStates.values.expand((e) => e.elements).firstOrNull;

    useEffect(() {
      if (selected?.origin.creationStackTrace case final trace?) {
        Future(() => openTraceInIDE(ref, Trace.parse(trace)));
      }

      return null;
    }, [selected?.origin.creationStackTrace]);

    return SplitPane(
      axis: Axis.horizontal,
      initialFractions: const [0.3, 0.7],
      children: [
        _ProviderPickerPanel(
          searchController: searchController,
          originStates: originStates,
          selectedId: selected?.element.provider.elementId,
          onSelected: (value) {
            selectedId.value = value?.elementId;
          },
        ),

        if (selected case final selected?)
          ProviderViewer(
            state: selected.element.state.state,
            notifier: selected.element.notifier.state,
          )
        else
          const Panel(child: Text('No provider selected')),
      ],
    );
  }
}

class ProviderViewer extends StatelessWidget {
  const ProviderViewer({
    super.key,
    required this.state,
    required this.notifier,
  });

  final RootCachedObject state;
  final RootCachedObject notifier;

  @override
  Widget build(BuildContext context) {
    return SplitPane(
      axis: .vertical,
      initialFractions: const [0.8, 0.2],
      children: [
        Panel(
          child: Padding(
            padding: const .symmetric(vertical: 8),
            child: Inspector(object: state),
          ),
        ),
        Terminal(state: state, notifier: notifier),
      ],
    );
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
            if (associatedProviders.foundCount == 1)
              _Tile(
                indent: null,
                onTap: () {
                  onSelected(
                    associatedProviders.elements.single.element.provider,
                  );
                },
                selected:
                    associatedProviders.foundCount == 1 &&
                    associatedProviders.elements.single.isSelected(selectedId),
                hash: associatedProviders.elements.single.origin.hashValue,
                creationStackTrace: associatedProviders
                    .elements
                    .single
                    .element
                    .provider
                    .creationStackTrace,
                containerHash: associatedProviders
                    .elements
                    .single
                    .element
                    .provider
                    .containerHashValue,
                associatedProviders.elements.single.originMatch,
              )
            else
              _Heading(associatedProviders.elements.first.originMatch),

            if (associatedProviders.foundCount > 1) ...[
              for (final (index, providerState)
                  in associatedProviders.elements.indexed)
                _Tile(
                  onTap: () => onSelected(providerState.element.provider),
                  selected: providerState.isSelected(selectedId),
                  hash: providerState.element.provider.hashValue,
                  creationStackTrace:
                      providerState.element.provider.creationStackTrace,
                  containerHash:
                      providerState.element.provider.containerHashValue,
                  indent: index == associatedProviders.elements.length - 1
                      ? '└─'
                      : '├─',
                  providerState.argMatch,
                ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {super.key});

  final FuzzyMatch text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FuzzyText(match: text),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
    this.text, {
    super.key,
    this.selected = false,
    required this.onTap,
    required this.indent,
    required this.hash,
    required this.containerHash,
    required this.creationStackTrace,
  });

  final FuzzyMatch text;
  final String? indent;
  final bool selected;
  final void Function()? onTap;
  final String hash;
  final String containerHash;
  final String? creationStackTrace;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.selectedRowBackgroundColor
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            spacing: 10,
            children: [
              if (indent case final indent?)
                Text(
                  indent,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              Expanded(child: FuzzyText(match: text)),
            ],
          ),
        ),
      ),
    );
  }
}
