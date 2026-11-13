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

final user = ref.watch(userProvider('123'));
