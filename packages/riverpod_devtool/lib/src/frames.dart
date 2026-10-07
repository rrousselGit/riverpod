// ignore_for_file: invalid_use_of_internal_member

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:devtools_app_shared/service.dart' show CancelledException;
import 'package:devtools_app_shared/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:material_ui/material_ui.dart';

import 'collection.dart';
import 'elements.dart';
import 'frame_view.dart';
import 'provider_list.dart';
import 'providers/providers.dart';
import 'riverpod.dart';
import 'vm_service.dart';

enum ProviderStatusInFrame { added, modified, disposed }

extension type FrameId(int value) {}

/// Provider that filters frames to only include those with state changes
/// (creation, update, or deletion).
final filteredFramesProvider = Provider<AsyncValue<List<FoldedFrame>>>(
  name: 'filteredFramesProvider',
  (ref) {
    final frames = ref.watch(framesProvider);
    return frames.whenData(
      (frames) => frames.where((f) => f.hasStateChanges).toList(),
    );
  },
);

final selectedFrameIdProvider =
    NotifierProvider<StateNotifier<FrameId?>, FrameId?>(
      name: 'selectedFrameIdProvider',
      () => StateNotifier<FrameId?>((ref, self) {
        // Clear selected frame on hot-restart, due to frames being cleared too
        ref.watch(hotRestartEventProvider);

        ref.listen(filteredFramesProvider, fireImmediately: true, (
          previous,
          next,
        ) {
          late final wasLastSelectedFrame =
              previous?.value?.lastOrNull?.id == self.state;
          late final newFramesContainsId =
              next.value?.map((frame) => frame.id).contains(self.state) ??
              false;

          if (self.stateOrNull == null ||
              wasLastSelectedFrame ||
              !newFramesContainsId) {
            self.state = next.value?.lastOrNull?.id;
          }
        });

        return self.stateOrNull;
      }),
    );

final selectedFrameProvider = Provider<FoldedFrame?>(
  name: 'selectedFrameProvider',
  (ref) {
    final frames = ref.watch(filteredFramesProvider);
    final selectedFrameId = ref.watch(selectedFrameIdProvider);

    if (selectedFrameId == null) return null;

    final frame = frames.value
        ?.where((frame) => frame.id == selectedFrameId)
        .firstOrNull;
    if (frame == null) {
      throw StateError(
        'Selected frame with id ${selectedFrameId.value} not found among '
        '${frames.value?.length ?? 0} available frames',
      );
    }

    return frame;
  },
);

final framesProvider =
    AsyncNotifierProvider.autoDispose<FramesNotifier, List<FoldedFrame>>(
      FramesNotifier.new,
      name: 'framesProvider',
    );

class AccumulatedState {
  AccumulatedState._({required this.providers});

  final UnmodifiableMap<internals.ElementId, ProviderStateRef> providers;
}

@immutable
final class FoldedFrame {
  FoldedFrame({
    required this.frame,
    required this.previous,
    List<Frame> newFrames = const [],
  }) {
    final previous = this.previous;
    if (previous != null) {
      if (frame.timestamp.isBefore(previous.frame.timestamp)) {
        throw StateError(
          'Frames must be in chronological order. Current: '
          '${frame.timestamp} at ${frame.index}, previous: ${previous.frame.timestamp} at ${previous.frame.index}',
        );
      }

      if (frame.index != previous.frame.index + 1) {
        throw StateError(
          'Frame index must be strictly increasing. '
          '${_debugGetAllFrameIndexes().join(' -> ')} // new frames indexes: ${newFrames.map((f) => f.index).join(', ')}',
        );
      }
    } else {
      if (frame.index != 0) {
        throw StateError('The first frame must have index 0');
      }
    }
  }

  List<int> _debugGetAllFrameIndexes() {
    final indexes = <int>[];
    for (
      FoldedFrame? current = this;
      current != null;
      current = current.previous
    ) {
      indexes.add(current.frame.index);
    }
    return indexes.toList();
  }

  FrameId get id => FrameId(frame.index);

  final Frame frame;
  final FoldedFrame? previous;

  late final elements = computeElementsForFrame(this);

  ProviderStatusInFrame? statusOf(internals.ElementId id) {
    for (final event in frame.events) {
      switch (event) {
        case ProviderElementAddEvent(:final provider)
            when provider.elementId == id:
          return ProviderStatusInFrame.added;
        case ProviderElementUpdateEvent(:final provider)
            when provider.elementId == id:
          return ProviderStatusInFrame.modified;
        case ProviderElementDisposeEvent(:final provider)
            when provider.elementId == id:
          return ProviderStatusInFrame.disposed;
        case _:
          continue;
      }
    }

    return null;
  }

  /// Returns true if this frame contains at least one state update/creation/deletion.
  bool get hasStateChanges {
    for (final event in frame.events) {
      switch (event) {
        case ProviderElementAddEvent() ||
            ProviderElementUpdateEvent() ||
            ProviderElementDisposeEvent():
          return true;
        case _:
          continue;
      }
    }
    return false;
  }
}

class FramesNotifier extends AsyncNotifier<List<FoldedFrame>> {
  List<FoldedFrame>? _lastFrames;
  @override
  Future<List<FoldedFrame>> build() async {
    // On hot-restart, clear the frames list.
    ref.watch(hotRestartEventProvider);
    _lastFrames = null;
    final isAlive = ref.disposable();
    final sessionFuture = ref.watch(devtoolSessionProvider.future);
    final serviceFuture = ref.watch(vmServiceProvider.future);
    final evalFuture = ref.watch(riverpodEvalProvider.future);
    final sessionId = await sessionFuture;
    final service = await serviceFuture;
    final riverpodEval = await evalFuture;
    if (isAlive.disposed) throw CancelledException();

    final sub = service.onNotification
        // Using asyncMap to ensure that notifications are processed in order
        // and one at a time.
        .asyncMap((event) async {
          switch (event) {
            case internals.NewEventNotification():
              await _fetchNewNotifications(
                event,
                sessionId: sessionId,
                riverpodEval: riverpodEval,
                isAlive: isAlive,
              );
          }
        })
        .listen(
          (_) {},
          onError: (Object error, StackTrace stackTrace) {
            if (isAlive.disposed || error is CancelledException) return;
            state = AsyncError(error, stackTrace);
          },
        );
    ref.onDispose(sub.cancel);

    final rawFrames = await _evalFrames(
      riverpodEval,
      isAlive,
      sessionId: sessionId,
    );
    return _lastFrames = foldFrames(const [], rawFrames);
  }

  Future<List<Frame>> _evalFrames(
    Eval eval,
    Disposable isAlive, {
    required String sessionId,
    int startIndex = 0,
  }) async {
    final code = encodeList(
      'RiverpodDevtool.instance.frames.skip('
      'RiverpodDevtool.instance.frames.length == 1 ? 0 : $startIndex)',
      (e, path) => "$e.toBytes(path: '$path')",
      path: 'root',
    );

    final instanceByte = await eval.evalInstance(
      'RiverpodDevtool.instance.withFrameCache("$sessionId", () => $code)',
      isAlive: isAlive,
    );
    if (isAlive.disposed) throw CancelledException();
    if (instanceByte case ByteError(error: ExpiredDevtoolSessionType())) {
      // A throttled/suspended tab can miss heartbeats. Opening a new session
      // rebuilds this provider and fetches the full current snapshot.
      ref.invalidate(devtoolSessionProvider);
      throw CancelledException();
    }
    // TODO remove require
    final instance = instanceByte.require.instance;
    final map = Map.fromEntries(
      instance.associations!.map((e) {
        final key = VmInstanceRef.fromObject(e.key);
        final value = VmInstanceRef.fromObject(e.value);

        return MapEntry(key.valueAsString!, value);
      }),
    );

    return decodeAll<Frame>(map, Frame.from, path: 'root').toList();
  }

  Future<void> _fetchNewNotifications(
    internals.NewEventNotification notification, {
    required String sessionId,
    required Eval riverpodEval,
    required Disposable isAlive,
  }) async {
    final frames = state.value ?? _lastFrames ?? await future;
    final replacesHistory = notification.offset == 0;
    final alreadyHasNewFrame =
        !state.hasError &&
        !replacesHistory &&
        notification.offset <= frames.length - 1;
    if (alreadyHasNewFrame) return;

    final newFrames = await _evalFrames(
      riverpodEval,
      isAlive,
      sessionId: sessionId,
      startIndex: replacesHistory ? 0 : frames.length,
    );

    state = AsyncData(_lastFrames = foldFrames(frames, newFrames));
  }
}

/// A frame at index zero replaces the baseline when history is not retained.
List<FoldedFrame> foldFrames(
  List<FoldedFrame> previousFrames,
  List<Frame> newFrames,
) {
  final result = newFrames.firstOrNull?.index == 0
      ? <FoldedFrame>[]
      : [...previousFrames];
  for (final frame in newFrames) {
    result.add(
      FoldedFrame(
        frame: frame,
        previous: result.lastOrNull,
        newFrames: newFrames,
      ),
    );
  }
  return result;
}

final timeTravelProvider =
    AsyncNotifierProvider.autoDispose<TimeTravelNotifier, bool>(
      TimeTravelNotifier.new,
    );

class TimeTravelNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Re-read the application's flag after frames change, including changes
    // made directly through debugTrackProviderHistory and hot restarts.
    ref.watch(framesProvider);
    final isAlive = ref.disposable();
    final eval = await ref.watch(riverpodEvalProvider.future);
    final result = await eval.eval(
      'debugTrackProviderHistory',
      isAlive: isAlive,
    );
    return result.require.instance.valueAsString == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    // Changing the flag emits a frame notification, which can rebuild this
    // provider before the assignment's VM response arrives.
    final isAlive = Disposable();
    try {
      final eval = await ref.read(riverpodEvalProvider.future);
      final result = await eval.eval(
        'debugTrackProviderHistory = $enabled',
        isAlive: isAlive,
      );
      result.require;
      if (ref.mounted) ref.invalidateSelf();
    } finally {
      isAlive.dispose();
    }
  }
}

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
