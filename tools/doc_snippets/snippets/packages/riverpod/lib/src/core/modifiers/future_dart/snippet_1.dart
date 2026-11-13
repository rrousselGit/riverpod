// GENERATED from packages/riverpod/lib/src/core/modifiers/future.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

class Config {
  String get host => '';
}

typedef Configs = Config;

final configsProvider = FutureProvider((ref) async => Configs());

final productsProvider = FutureProvider((ref) async {
  // Wait for the configurations to resolve
  final configs = await ref.watch(configsProvider.future);

  // Do something with the result
  return await http.get(Uri.parse('${configs.host}/products'));
});
