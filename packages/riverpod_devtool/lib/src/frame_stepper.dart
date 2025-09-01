import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'event.dart';

class FrameStepper extends HookConsumerWidget {
  const FrameStepper({super.key, required this.selectedFrameIndex});

  static const _stepperHeight = 50.0;

  final int? selectedFrameIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frames = ref.watch(framesProvider);

    switch (frames) {
      case AsyncValue(:final value?):
        return SizedBox(
          height: _stepperHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [for (final frame in value) _FrameStep(frame: frame)],
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
  const _FrameStep({super.key, required this.frame});

  final FoldedFrame frame;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('HH:mm:ss.SSS');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(format.format(frame.frame.timestamp)),
    );
  }
}
