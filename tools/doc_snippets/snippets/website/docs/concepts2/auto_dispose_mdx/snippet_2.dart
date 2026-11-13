// GENERATED from website/docs/concepts2/auto_dispose.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final helloWorldProvider = Provider<String>(
  // Opt-in to automatic disposal
  isAutoDispose: true,
  (ref) => 'Hello world!',
);
