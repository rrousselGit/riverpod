// GENERATED from website/docs/concepts2/scoping.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentItemIdProvider = Provider<String?>(
  dependencies: const [],
  (ref) => null,
);
late WidgetRef ref;

final currentItemId = ref.watch(currentItemIdProvider);
