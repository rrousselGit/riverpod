// GENERATED from packages/riverpod/lib/src/providers/notifier/orphan.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

// The snippet that defines Counter, for the ones that use it.
import 'counter.dart';

dynamic snippet() async => Consumer(
  builder: (context, ref, child) {
    return ElevatedButton(
      onPressed: () => ref.read(counterProvider.notifier).increment(),
      child: const Text('increment'),
    );
  },
);
