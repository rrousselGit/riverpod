// GENERATED from website/docs/concepts2/auto_dispose.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Disable automatic disposal
@Riverpod(keepAlive: true)
String helloWorld(Ref ref) => 'Hello world!';
