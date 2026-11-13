import 'dart:math' as math;

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';

import 'frame_view.dart';
import 'provider_list.dart';

class FrameStepper extends HookConsumerWidget {
  const FrameStepper({
    super.key,
    required this.onSelect,
    required this.selectedFrame,
    required this.selectedElement,
  });

  final void Function(FrameId frame) onSelect;
  final FoldedFrame? selectedFrame;
  final FilteredElement? selectedElement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracking = ref.watch(timeTravelProvider);
    final busy = useState(false);
    final enabled = tracking.value ?? false;
    final canToggle = !busy.value && tracking.hasValue && !tracking.hasError;

    return Row(
      children: [
        Tooltip(
          message: enabled
              ? 'Stop time travel and discard previous frames'
              : 'Start time travel and record future frames',
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: BorderSide.none,
              elevation: 0,
            ),
            iconSize: 20,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: Icon(enabled ? Icons.stop : Icons.play_arrow),
            onPressed: !canToggle
                ? null
                : () async {
                    busy.value = true;
                    try {
                      await ref
                          .read(timeTravelProvider.notifier)
                          .setEnabled(!enabled);
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Could not change time travel: $error',
                            ),
                          ),
                        );
                      }
                    } finally {
                      if (context.mounted) busy.value = false;
                    }
                  },
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: enabled ? 1 : 0.4,
            child: IgnorePointer(
              ignoring: !enabled,
              child: _FrameTimeline(
                enabled: enabled,
                onSelect: onSelect,
                selectedFrame: selectedFrame,
                selectedElement: selectedElement,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FrameTimeline extends HookConsumerWidget {
  const _FrameTimeline({
    required this.enabled,
    required this.onSelect,
    required this.selectedFrame,
    required this.selectedElement,
  });

  final bool enabled;

  static const _stepperHeight = 50.0;

  final void Function(FrameId frame) onSelect;
  final FoldedFrame? selectedFrame;
  final FilteredElement? selectedElement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final frames = ref.watch(filteredFramesProvider);

    void select(FrameId frame) {
      onSelect(frame);
    }

    void scrollToFrame(FrameId frame) {
      if (!controller.hasClients) return;

      final framesValue = frames.value;
      if (framesValue == null) return;

      final index = framesValue.indexWhere((f) => f.id == frame);
      if (index == -1) return;

      final offset = index * 30.0; // itemExtent

      final viewport = controller.position.viewportDimension;
      final currentOffset = controller.offset;

      if (offset < currentOffset) {
        controller.animateTo(
          offset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else if (offset + 30.0 > currentOffset + viewport) {
        controller.animateTo(
          offset - viewport + 30.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }

    // Keep the stepper scrolled to the selected frame, whether the
    // selection changed from a manual tap/button press or automatically
    // (e.g. a new frame streaming in becomes the selected one).
    useEffect(() {
      final frame = selectedFrame;
      if (frame != null) {
        scrollToFrame(frame.id);
      }
      return null;
    }, [selectedFrame, frames]);

    switch (frames) {
      case AsyncValue(:final value?):
        if (value.isEmpty) {
          return const SizedBox(
            height: _stepperHeight,
            child: Center(child: Text('No frames with state changes')),
          );
        }
        assert(
          selectedFrame != null,
          'Even though frames.length > 0, selectedFrame is null',
        );

        final currentIndex = value.indexOf(selectedFrame!);
        final canGoFirst = enabled && currentIndex > 0;
        final canGoPrevious = enabled && currentIndex > 0;
        final canGoNext = enabled && currentIndex < value.length - 1;
        final canGoLast = enabled && currentIndex < value.length - 1;

        return SizedBox(
          height: _stepperHeight,
          child: Row(
            mainAxisAlignment: .center,
            children: [
              _NavigationButton(
                icon: Icons.first_page,
                tooltip: 'First frame',
                onPressed: canGoFirst ? () => select(value.first.id) : null,
              ),
              _NavigationButton(
                icon: Icons.chevron_left,
                tooltip: 'Previous frame',
                onPressed: canGoPrevious
                    ? () => select(value[currentIndex - 1].id)
                    : null,
              ),
              Flexible(
                child: Scrollbar(
                  controller: controller,
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    controller: controller,
                    itemCount: value.length,
                    scrollDirection: Axis.horizontal,
                    itemExtent: 30,
                    itemBuilder: (context, index) {
                      final frame = value[index];

                      return _FrameStep(
                        frame: frame,
                        isSelected: frame == selectedFrame,
                        status: switch (selectedElement) {
                          null => null,
                          final element => frame.statusOf(
                            element.element.provider.elementId,
                          ),
                        },
                        onTap: enabled ? () => select(frame.id) : null,
                      );
                    },
                  ),
                ),
              ),
              _NavigationButton(
                icon: Icons.chevron_right,
                tooltip: 'Next frame',
                onPressed: canGoNext
                    ? () => select(value[currentIndex + 1].id)
                    : null,
              ),
              _NavigationButton(
                icon: Icons.last_page,
                tooltip: 'Last frame',
                onPressed: canGoLast ? () => select(value.last.id) : null,
              ),
            ],
          ),
        );
      case AsyncValue(error: != null):
        return const SizedBox(
          height: _stepperHeight,
          child: Text('Error while connecting to the Riverpod application'),
        );
      case AsyncValue():
        return Container(
          alignment: Alignment.center,
          height: _stepperHeight,
          child: const Text(
            'Waiting to connect to the Riverpod application...',
          ),
        );
    }
  }
}

class _FrameStep extends StatelessWidget {
  const _FrameStep({
    super.key,
    required this.frame,
    required this.isSelected,
    required this.onTap,
    required this.status,
  });

  final FoldedFrame frame;
  final bool isSelected;
  final ProviderStatusInFrame? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    const borderWidth = 3.0;
    final size = isSelected ? 20.0 + borderWidth * 2 : 15.0;

    final color = switch (status) {
      ProviderStatusInFrame.added ||
      ProviderStatusInFrame.modified => theme.colorScheme.primary,
      ProviderStatusInFrame.disposed => Colors.red,
      null => theme.colorScheme.onSurface.withValues(alpha: 0.5),
    };

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: _FrameTooltip(
          frame: frame,
          child: _Circle(
            size: size,
            color: color,
            border: isSelected
                ? .all(color: borderColor, width: borderWidth)
                : null,
          ),
        ),
      ),
    );
  }
}

class _FrameTooltip extends StatelessWidget {
  const _FrameTooltip({super.key, required this.child, required this.frame});

  final Widget child;
  final FoldedFrame frame;

  @override
  Widget build(BuildContext context) {
    return RawTooltip(
      positionDelegate: (position) {
        return Offset(
          math.max(position.target.dx - position.tooltipSize.width / 2, 10),
          math.max(position.target.dy - position.tooltipSize.height - 20, 10),
        );
      },
      semanticsTooltip: null,
      tooltipBuilder: (context, animation) {
        return HookConsumer(
          builder: (context, ref, _) {
            final originStates = ref.watch(
              filteredProvidersProvider((search: '', frame: frame.id)),
            );

            return _FrameTooltipBody(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProviderList(
                  shrinkWrap: true,
                  showOthers: false,
                  originStates: originStates,
                ),
              ),
            );
          },
        );
      },
      child: child,
    );
  }
}

class _FrameTooltipBody extends StatelessWidget {
  const _FrameTooltipBody({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(5));

    return ConstrainedBox(
      constraints: const .new(maxWidth: 400, maxHeight: 600),
      child: Material(
        elevation: 4,
        borderRadius: borderRadius,
        clipBehavior: .hardEdge,
        child: Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius,
            border: .all(color: Theme.of(context).panelBorderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    super.key,
    required this.size,
    required this.color,
    this.border,
  });

  final double size;
  final Color color;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: .circle, border: border, color: color),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: 20,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
