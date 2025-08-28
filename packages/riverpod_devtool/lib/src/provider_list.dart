import 'package:devtools_app_shared/ui.dart' as devtools_shared_ui;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'event.dart';
import 'state_view.dart';
import 'ui.dart';

class ProviderListView extends HookConsumerWidget {
  const ProviderListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedFrameIndex = useState<int>(0);
    final frames = ref.watch(framesProvider);

    final selectedFrame = frames.value?.frames.elementAtOrNull(
      selectedFrameIndex.value,
    );

    return devtools_shared_ui.SplitPane(
      axis: Axis.horizontal,
      initialFractions: const [0.3, 0.7],
      minSizes: const [50.0, 100.0],
      children: [
        Panel(
          header: const Text('Providers'),
          child: switch (frames) {
            AsyncLoading<Frames>() => const Center(
              child: CircularProgressIndicator(),
            ),
            AsyncError<Frames>() => Center(
              child: Text('Error ${frames.error}\n${frames.stackTrace}'),
            ),
            AsyncData<Frames>() => Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                itemCount: frames.value.frames.length,
                itemBuilder: (context, index) {
                  final frame = frames.value.frames[index];
                  return ListTile(
                    title: Text('Frame #${frame.frame.index}'),
                    selected: selectedFrameIndex.value == index,
                    subtitle: Text(
                      'Timestamp: ${frame.frame.timestamp.toIso8601String()}\n'
                      'Events: ${frame.frame.events.length}',
                    ),
                    onTap: () => selectedFrameIndex.value = index,
                  );
                },
              ),
            ),
          },
        ),
        Panel(
          child: selectedFrame == null
              ? const Center(child: Text('No frame selected'))
              : _FrameView(frame: selectedFrame),
        ),
      ],
    );
  }
}

class _FrameView extends StatelessWidget {
  const _FrameView({super.key, required this.frame});

  final FoldedFrame frame;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: frame.frame.events.length,
      itemBuilder: (context, index) {
        final event = frame.frame.events[index];

        final (title, subtitle) = switch (event) {
          ProviderContainerAddEvent() => (
            'ProviderContainerAddEvent',
            '${event.containerId} // ${event.parentIds}',
          ),
          ProviderContainerDisposeEvent() => (
            'ProviderContainerDisposeEvent',
            '${event.container}',
          ),
          ProviderElementAddEvent() => (
            'ProviderElementAddEvent',
            '${event.element}',
          ),
          ProviderElementDisposeEvent() => (
            'ProviderElementDisposeEvent',
            '${event.element}',
          ),
          ProviderElementUpdateEvent() => (
            'ProviderElementUpdateEvent',
            'Previous: ${event.previous}\n'
                'Next: ${event.next}',
          ),
        };

        return ListTile(title: Text(title), subtitle: Text(subtitle));
      },
    );
  }
}
