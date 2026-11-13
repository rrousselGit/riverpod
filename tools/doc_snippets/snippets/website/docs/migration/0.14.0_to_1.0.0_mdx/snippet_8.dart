// GENERATED from website/docs/migration/0.14.0_to_1.0.0.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final counterProvider = Provider<int>((ref) => 0);

class MyNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void doSomething() {}
}

final provider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

class SomeButton extends StatelessWidget {
  const SomeButton({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SomeButton(
      onPressed: () => ref.read(provider.notifier).doSomething(),
    );
  }
}
