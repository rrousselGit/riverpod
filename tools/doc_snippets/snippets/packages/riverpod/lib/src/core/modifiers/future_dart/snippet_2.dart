// GENERATED from packages/riverpod/lib/src/core/modifiers/future.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

class Config {
  String get host => '';
}

typedef Configs = Config;

// A provider which asynchronously loads configurations,
// which may change over time.
final configsProvider = StreamProvider<Config>((ref) async* {
  // TO-DO fetch the configurations, such as by using Firebase
});

// A provider which fetches a list of products based on the configurations
final productsProvider = FutureProvider((ref) async {
  // We obtain the host from the configs, while ignoring changes to
  // other properties. As such, the productsProvider will rebuild only
  // if the host changes
  final host = await ref.watch(
    configsProvider.selectAsync((config) => config.host),
  );

  return http.get(Uri.parse('$host/products'));
});
