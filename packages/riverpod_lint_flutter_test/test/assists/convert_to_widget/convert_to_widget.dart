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
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return const Placeholder();
  }
}

class Stateful extends StatefulWidget {
  const Stateful({super.key});

  @override
  State<Stateful> createState() => _StatefulState();
}

class _StatefulState extends State<Stateful> {
  /// Hello world
  @override
  Widget build(BuildContext context) {
    // Some comments
    return const Placeholder();
  }
}

class ExplicitCreateState extends StatefulWidget {
  const ExplicitCreateState({super.key});

  @override
  ExplicitCreateStateState createState() => ExplicitCreateStateState();
}

class ExplicitCreateStateState extends State<ExplicitCreateState> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return const Placeholder();
  }
}

class HookStateful extends StatefulHookWidget {
  const HookStateful({super.key});

  @override
  State<HookStateful> createState() => HookStatefulState();
}

class HookStatefulState extends State<HookStateful> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ConsumerStateful extends ConsumerStatefulWidget {
  const ConsumerStateful({super.key});

  @override
  ConsumerState<ConsumerStateful> createState() => _ConsumerStatefulState();
}

class _ConsumerStatefulState extends ConsumerState<ConsumerStateful> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HookConsumerStateful extends StatefulHookConsumerWidget {
  const HookConsumerStateful({super.key});

  @override
  ConsumerState<HookConsumerStateful> createState() =>
      _HookConsumerStatefulState();
}

class _HookConsumerStatefulState extends ConsumerState<HookConsumerStateful> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Consumer extends ConsumerWidget {
  const Consumer({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return const Placeholder();
  }
}

class StatelessWithField extends StatelessWidget {
  const StatelessWithField({
    super.key,
    required this.field,
  });

  final int field;
  static final int staticField = 42;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$field'),
        Text('$staticField'),
      ],
    );
  }
}

class HookConsumerWithField extends HookConsumerWidget {
  const HookConsumerWithField({
    super.key,
    required this.field,
  });

  final int field;
  static final int staticField = 42;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Column(
      children: [
        Text('$field'),
        Text('$staticField'),
      ],
    );
  }
}

class FooClass {
  final bar = 42;
}

class ConsumerStatefulWithField extends ConsumerStatefulWidget {
  const ConsumerStatefulWithField({
    super.key,
    required this.field,
    required this.foo,
  });

  final int field;
  final FooClass foo;
  static final int staticField = _constantNumber;

  @override
  ConsumerState<ConsumerStatefulWithField> createState() =>
      _ConsumerStatefulWithFieldState();
}

const _constantNumber = 42;

class _ConsumerStatefulWithFieldState
    extends ConsumerState<ConsumerStatefulWithField> {
  void printFoo() {
    print(widget.foo);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.field);
    printFoo();
    return Column(
      children: [
        Text('${widget.field}'),
        Text('${widget.foo.bar}'),
        Text('${ConsumerStatefulWithField.staticField}'),
      ],
    );
  }
}
