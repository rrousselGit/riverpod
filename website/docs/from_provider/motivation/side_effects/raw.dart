import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auto_dispose/auto_dispose.dart';

/* SNIPPET START */

class DiceRollWidget extends ConsumerWidget {
  const DiceRollWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(diceRollProvider, (previous, next) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dice roll! We got: $next')),
      );
    });
    return TextButton.icon(
      onPressed: () => ref.invalidate(diceRollProvider),
      icon: const Icon(Icons.casino),
      label: const Text('Roll a dice'),
    );
  }
}
