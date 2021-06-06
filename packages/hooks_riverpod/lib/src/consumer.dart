import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'internals.dart';

abstract class HookConsumerWidget extends ConsumerWidget {
  const HookConsumerWidget({Key? key}) : super(key: key);

  @override
  _HookConsumerElement createElement() => _HookConsumerElement(this);
}

// ignore: invalid_use_of_visible_for_testing_member
class _HookConsumerElement extends ConsumerStatefulElement with HookElement {
  _HookConsumerElement(HookConsumerWidget widget) : super(widget);
}

class HookConsumer extends HookConsumerWidget {
  const HookConsumer({Key? key, required this.builder, this.child})
      : super(key: key);

  final ConsumerBuilder builder;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetReference ref) {
    return builder(context, ref, child);
  }
}
