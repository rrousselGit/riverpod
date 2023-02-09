import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Stateless extends StatelessWidget {
  const Stateless({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class StatelessWithComma extends StatelessWidget {
  const StatelessWithComma({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Placeholder();
  }
}

class Hook extends HookWidget {
  const Hook({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HookConsumer extends HookConsumerWidget {
  const HookConsumer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder();
  }
}
