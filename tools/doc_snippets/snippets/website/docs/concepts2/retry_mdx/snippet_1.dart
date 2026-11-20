// GENERATED from website/docs/concepts2/retry.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

final myProvider = FutureProvider<int>((ref) async => 0);
late Ref ref;

Duration? myRetry(int retryCount, Object error) {
  // Stop retrying after 5 attempts
  if (retryCount >= 5) return null;
  // Ignore ProviderException
  if (error is ProviderException) return null;

  return Duration(milliseconds: 200 * (1 << retryCount)); // Exponential backoff
}
