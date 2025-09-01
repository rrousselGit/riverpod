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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _FramePanel(selectedFrameIndex: selectedFrameIndex.value),
        ),
        FrameStepper(selectedFrameIndex: selectedFrameIndex.value),
      ],
    );
  }
}

class _FramePanel extends ConsumerWidget {
  const _FramePanel({super.key, required this.selectedFrameIndex});

  final int? selectedFrameIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrameIndex = this.selectedFrameIndex;
    final selectedFrame = ref.watch(
      framesProvider.select(
        (frames) => selectedFrameIndex == null
            ? frames.value?.lastOrNull
            : frames.value?.elementAtOrNull(selectedFrameIndex),
      ),
    );

    if (selectedFrame == null) {
      return const Panel(child: Center(child: Text('No frame selected')));
    }

    return _FrameViewer(frame: selectedFrame);
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
          Panel(child: _StateView(state: selected))
        else
          const Panel(child: Text('No provider selected')),
      ],
    );
  }
}

class _StateView extends StatelessWidget {
  const _StateView({super.key, required this.state});

  final ProviderMeta state;

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(state.displayString)]);
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
            _Tile(
              onTap: meta.associatedProviders.length == 1
                  ? () => onSelected(meta.associatedProviders.values.single.elementId)
                  : null,
              selected:
                  meta.associatedProviders.length == 1 &&
                  meta.associatedProviders.values.single.isSelected(selectedId),
              meta.value.displayString,
            ),

            if (meta.associatedProviders.length > 1) ...[
              for (final (index, providerState)
                  in meta.associatedProviders.values.indexed)
                if (index == meta.associatedProviders.length - 1)
                  _Tile(
                    onTap: () => onSelected(providerState.elementId),
                    selected: providerState.isSelected(selectedId),
                    '└─ ${providerState.toStringValue}',
                  )
                else
                  _Tile(
                    onTap: () => onSelected(providerState.elementId),
                    selected: providerState.isSelected(selectedId),
                    '├─ ${providerState.toStringValue}',
                  ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
    this.text, {
    super.key,
    this.selected = false,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}
