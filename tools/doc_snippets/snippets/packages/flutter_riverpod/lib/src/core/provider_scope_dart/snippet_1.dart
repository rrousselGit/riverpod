// GENERATED from packages/flutter_riverpod/lib/src/core/provider_scope.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class MyApp extends SizedBox {}

class Home extends SizedBox {}

class Gallery extends SizedBox {}

class MyTheme {
  MyTheme.light();
  MyTheme.dark();
}

class Repository {}

class FakeRepository implements Repository {}

final repositoryProvider = Provider<Repository>((ref) => Repository());

void main() {
  runApp(
    // Enabled Riverpod for the entire application
    ProviderScope(child: MyApp()),
  );
}
