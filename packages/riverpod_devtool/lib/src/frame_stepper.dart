import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'event.dart';

class FrameStepper extends HookConsumerWidget {
  const FrameStepper({
    super.key,
    required this.selectedFrameIndex,
    required this.onSelect,
  });

  static const _stepperHeight = 50.0;

  final int? selectedFrameIndex;
  final void Function(int index) onSelect;

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
                  isSelected: selectedFrameIndex == frame.frame.index,
                  onTap: () => onSelect(frame.frame.index),
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
  });

  final FoldedFrame frame;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = isSelected ? 20.0 : 15.0;

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 2),
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
