import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'internals.dart';

/// {@template hooks_riverpod.hookconsumer.hookconsumerwidget}
/// A widget that can both use hooks and listen to providers.
///
/// If you do not need hooks, you can use [Consumer].
/// {@endtemplate}
abstract class HookConsumerWidget extends ConsumerWidget {
  /// {@macro hooks_riverpod.hookconsumer.hookconsumerwidget}
  const HookConsumerWidget({Key? key}) : super(key: key);

  @override
  _HookConsumerElement createElement() => _HookConsumerElement(this);
}

// ignore: invalid_use_of_visible_for_testing_member
class _HookConsumerElement extends ConsumerStatefulElement with HookElement {
  _HookConsumerElement(HookConsumerWidget widget) : super(widget);
}

/// {@macro hooks_riverpod.hookconsumer.hookconsumerwidget}

class HookConsumer extends HookConsumerWidget {
  /// {@macro hooks_riverpod.hookconsumer.hookconsumerwidget}
  const HookConsumer({Key? key, required this.builder, this.child})
      : super(key: key);

  /// A function that builds a widget.
  ///
  /// Can both listen to providers and use hooks.
  final ConsumerBuilder builder;

  /// An optional child widget that will be passed to [builder].
  ///
  /// This is useful for performance optimization, as this allows [builder] to
  /// be called again without rebuilding [child].
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return builder(context, ref, child);
  }
}
