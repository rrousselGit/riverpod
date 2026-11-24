// GENERATED from website/docs/root/faq.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

late WidgetRef ref;
late BuildContext context;
late Future<void> future;
final provider = Provider((ref) => 0);

class YourNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void yourMethod() {}
}

final yourNotifierProvider = NotifierProvider<YourNotifier, int>(
  YourNotifier.new,
);

class User {
  User(this.name);
  final String name;
}

final userProvider = Provider<User?>((ref) => null);

final userNameProvider = Provider((ref) {
  final user = ref.watch(userProvider);
  if (user == null) return null; // handles the brief invalid window
  return user.name;
});
