// GENERATED from website/docs/concepts2/family.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {}

final userProvider = FutureProvider.autoDispose.family<User, String>(
  (ref, id) async => User(),
);
final myProvider = Provider.family<int, List<int>>((ref, list) => 0);
late WidgetRef ref;

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user1 = ref.watch(userProvider('123'));
    final user2 = ref.watch(userProvider('456'));

    // user1 and user2 are independent.
    return const Placeholder();
  }
}
