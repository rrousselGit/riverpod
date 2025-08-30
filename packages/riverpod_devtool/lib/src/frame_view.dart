import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:intl/intl.dart';

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

    final dateFormat = DateFormat('HH:mm:ss.SSS');

    return Panel(
      header: Center(
        child: Text(
          'Frame ${dateFormat.format(selectedFrame.frame.timestamp)}',
        ),
      ),
      child: _FrameViewer(frame: selectedFrame),
    );
  }
}

class _FrameViewer extends ConsumerWidget {
  const _FrameViewer({super.key, required this.frame});

  final FoldedFrame frame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originStates = ref.watch(allDiscoveredOriginsProvider);

    return ListView(
      children: [
        for (final MapEntry(value: meta) in originStates.entries) ...[
          if (meta.isFamily) ...[
            Text(
              '${meta.originDisplayString} (${meta.associatedProviders.length} state(s))',
            ),
            for (final providerState in meta.associatedProviders.values)
              Text(providerState.providerDisplayString),
          ] else
            Text(meta.originDisplayString),
        ],
      ],
    );
  }
}
