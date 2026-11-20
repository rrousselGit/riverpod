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

final themeProvider = Provider((ref) => MyTheme.light());

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        // Home uses the default behavior for all providers.
        home: Home(),
        routes: {
          // Overrides themeProvider for the /gallery route only
          '/gallery': (_) => ProviderScope(
            overrides: [themeProvider.overrideWithValue(MyTheme.dark())],
            child: Gallery(),
          ),
        },
      ),
    ),
  );
}
