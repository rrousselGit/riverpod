// GENERATED from packages/riverpod_annotation/lib/src/riverpod_annotation.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

class Foo {}

@Riverpod(dependencies: [])
Foo scoped(Ref ref) => Foo();

final scopedProvider = Provider<Foo>(scoped);

class MyChangeNotifier extends ChangeNotifier {}

@Riverpod(dependencies: [scoped])
Object? dependent(Ref ref) {
  // Since "scopedProvider" specifies "dependencies", any provider that
  // depends on it must also specify "dependencies" and include "scopedProvider".
  return ref.watch(scopedProvider);
}
