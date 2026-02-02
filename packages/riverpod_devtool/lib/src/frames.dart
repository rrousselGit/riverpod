// ignore_for_file: invalid_use_of_internal_member

import 'dart:math' as math;

import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:vm_service/vm_service.dart' hide Frame;

import 'collection.dart';
import 'elements.dart';
import 'frame_view.dart';
import 'provider_list.dart';
import 'providers/providers.dart';
import 'riverpod.dart';
import 'ui_primitives/panel.dart';
import 'vm_service.dart';

enum ProviderStatusInFrame { added, modified, disposed }

extension type FrameId(int value) {}

final selectedFrameIdProvider =
    NotifierProvider<StateNotifier<FrameId?>, FrameId?>(
      name: 'selectedFrameIdProvider',
      () => StateNotifier<FrameId?>((ref, self) {
        // Clear selected frame on hot-restart, due to frames being cleared too
        ref.watch(hotRestartEventProvider);

        ref.listen(framesProvider, fireImmediately: true, (previous, next) {
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
    final frames = ref.watch(framesProvider);
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
      name: 'providerElementsProvider',
    );

class AccumulatedState {
  AccumulatedState._({required this.providers});

  final UnmodifiableMap<internals.ElementId, ProviderStateRef> providers;
}

@immutable
final class FoldedFrame {
  FoldedFrame({required this.frame, required this.previous}) {
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
          'Got ${previous.frame.index} followed by ${frame.index}',
        );
      }
    } else {
      if (frame.index != 0) {
        throw StateError('The first frame must have index 0');
      }
    }
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
}

class FramesNotifier extends AsyncNotifier<List<FoldedFrame>> {
  @override
  Future<List<FoldedFrame>> build() async {
    ref.listen(hotRestartEventProvider, (a, b) {
      print('Hot restart detected, clearing frames');
    });
    ref.listen(vmServiceProvider.future, (a, b) {
      print('VM service changed, clearing frames');
    });
    ref.listen(riverpodEvalProvider, (a, b) {
      print('Riverpod eval changed, clearing frames');
    });

    // On hot-restart, clear the frames list.
    ref.watch(hotRestartEventProvider);

    final service = await ref.watch(vmServiceProvider.future);

    final riverpodEval = await ref.watch(riverpodEvalProvider.future);
    final isAlive = ref.disposable();

    final sub = service.onNotification
        // Using asyncMap to ensure that notifications are processed in order
        // and one at a time.
        .asyncMap((event) async {
          switch (event) {
            case internals.NewEventNotification():
              await _fetchNewNotifications(
                event,
                riverpodEval: riverpodEval,
                isAlive: isAlive,
              );
          }
        })
        .listen((_) {});
    ref.onDispose(sub.cancel);

    final rawFrames = await _evalFrames(riverpodEval, isAlive);
    final firstFrame = rawFrames.firstOrNull;
    if (firstFrame == null) return const [];

    final mappedFrames = List.filled(
      rawFrames.length,
      FoldedFrame(frame: firstFrame, previous: null),
    );
    for (var i = 1; i < rawFrames.length; i++) {
      final previous = mappedFrames[i - 1];
      final rawFrame = rawFrames[i];

      mappedFrames[i] = FoldedFrame(frame: rawFrame, previous: previous);
    }

    return mappedFrames;
  }

  Future<List<Frame>> _evalFrames(
    Eval eval,
    Disposable isAlive, {
    int startIndex = 0,
  }) async {
    final code = encodeList(
      'RiverpodDevtool.instance.frames.sublist($startIndex)',
      (e, path) => "$e.toBytes(path: '$path')",
      path: 'root',
    );

    final instanceByte = await eval.evalInstance(code, isAlive: isAlive);
    // TODO remove require
    final instance = instanceByte.require.instance;
    final map = Map.fromEntries(
      instance.associations!.map((e) {
        return MapEntry(
          (e.key as InstanceRef).valueAsString!,
          e.value as InstanceRef,
        );
      }),
    );

    return decodeAll<Frame>(map, Frame.from, path: 'root').toList();
  }

  Future<void> _fetchNewNotifications(
    internals.NewEventNotification notification, {
    required Eval riverpodEval,
    required Disposable isAlive,
  }) async {
    final frames = await future;
    final alreadyHasNewFrame = notification.offset <= frames.length - 1;
    if (alreadyHasNewFrame) return;

    final newFrames = await _evalFrames(
      riverpodEval,
      isAlive,
      startIndex: math.max(frames.length, 0),
    );

    state = AsyncData([
      ...?state.value,
      for (final frame in newFrames)
        FoldedFrame(frame: frame, previous: state.value?.lastOrNull),
    ]);
  }
}

class FrameStepper extends HookConsumerWidget {
  const FrameStepper({
    super.key,
    required this.onSelect,
    required this.selectedFrame,
    required this.selectedElement,
  });

  static const _stepperHeight = 50.0;

  final void Function(FrameId frame) onSelect;
  final FoldedFrame? selectedFrame;
  final FilteredElement? selectedElement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final frames = ref.watch(framesProvider);

    switch (frames) {
      case AsyncValue(:final value?):
        return SizedBox(
          height: _stepperHeight,
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
                  onTap: () => onSelect(frame.id),
                );
              },
            ),
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
  final VoidCallback onTap;

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
      null => theme.colorScheme.onSurface.withOpacity(0.5),
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
                padding: const .symmetric(vertical: 8),
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
            border: .all(color: Theme.of(context).panelBorderColor, width: 1),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 2),
        border: border,
        color: color,
      ),
    );
  }
}
