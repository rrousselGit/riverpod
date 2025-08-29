import 'package:devtools_app_shared/ui.dart' as devtools_shared_ui;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'event.dart';
import 'ui.dart';

class FrameStepper extends HookConsumerWidget {
  const FrameStepper({super.key});

  static const _stepperHeight = 50.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrameIndex = useState<int>(0);
    final frames = ref.watch(framesProvider);

    final selectedFrame = frames.value?.elementAtOrNull(
      selectedFrameIndex.value,
    );

    print(frames);

    final Widget content;
    switch (frames) {
      case AsyncValue(:final value?):
        return SizedBox(
          height: _stepperHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              for (final frame in value) Text('Frame ${frame.frame.index}'),
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
  const _FrameStep({super.key, required this.frame});

  final FoldedFrame frame;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,

      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('foo'),
    );
  }
}
