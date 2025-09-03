import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'event.dart';
import 'frame_stepper.dart';
import 'providers.dart';
import 'ui.dart';

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
    final originStates = ref.watch(allDiscoveredOriginsProvider);

    final selected =
        originStates.values
            .expand((e) => e.associatedProviders.values)
            .where((e) => e.isSelected(selectedId.value))
            .firstOrNull ??
        originStates.values
            .expand((e) => e.associatedProviders.values)
            .firstOrNull;

    return SplitPane(
      axis: Axis.horizontal,
      initialFractions: const [0.3, 0.7],
      children: [
        _ProviderPickerPanel(
          originStates: originStates,
          selectedId: selected?.elementId,
          onSelected: (value) => selectedId.value = value,
        ),

        if (selected case final selected?)
          Panel(
            child: _StateView(meta: selected, frame: frame),
          )
        else
          const Panel(child: Text('No provider selected')),
      ],
    );
  }
}

class _StateView extends StatelessWidget {
  const _StateView({super.key, required this.meta, required this.frame});

  final ProviderMeta meta;
  final FoldedFrame frame;

  @override
  Widget build(BuildContext context) {
    final state = frame.state.providers[meta.elementId];

    return Column(children: [Text('${state?.state ?? '<...>'}')]);
  }
}

class _ProviderPickerPanel extends StatelessWidget {
  const _ProviderPickerPanel({
    super.key,
    required this.originStates,
    required this.selectedId,
    required this.onSelected,
  });

  final Map<internals.OriginId, OriginState> originStates;
  final internals.ElementId? selectedId;
  final void Function(internals.ElementId?) onSelected;

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final MapEntry(value: meta) in originStates.entries) ...[
            if (meta.associatedProviders.length == 1)
              _Tile(
                onTap: () => onSelected(
                  meta.associatedProviders.values.single.elementId,
                ),
                selected:
                    meta.associatedProviders.length == 1 &&
                    meta.associatedProviders.values.single.isSelected(
                      selectedId,
                    ),
                hash: meta.value.hashValue,
                containerHash:
                    meta.associatedProviders.values.single.containerHashValue,
                meta.value.toStringValue,
              )
            else
              _Heading(meta.value.toStringValue),

            if (meta.associatedProviders.length > 1) ...[
              for (final (index, providerState)
                  in meta.associatedProviders.values.indexed)
                if (index == meta.associatedProviders.length - 1)
                  _Tile(
                    onTap: () => onSelected(providerState.elementId),
                    selected: providerState.isSelected(selectedId),
                    hash: providerState.hashValue,
                    containerHash: providerState.containerHashValue,
                    '└─ ${providerState.toStringValue}',
                  )
                else
                  _Tile(
                    onTap: () => onSelected(providerState.elementId),
                    selected: providerState.isSelected(selectedId),
                    hash: providerState.hashValue,
                    containerHash: providerState.containerHashValue,
                    '├─ ${providerState.toStringValue}',
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
  });

  final String text;
  final bool selected;
  final void Function()? onTap;
  final String hash;
  final String containerHash;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RichText(
            text: TextSpan(
              text: text,
              style: DefaultTextStyle.of(context).style.copyWith(
                color: selected ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
