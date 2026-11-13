// GENERATED from packages/riverpod/lib/src/providers/provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:material_ui/material_ui.dart';

class MyValue {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}

Future<String> fetchWeather({required String city}) async => 'Sunny';

dynamic snippet() async {
  final themeProvider = Provider<ThemeData>(
    (ref) => throw UnimplementedError(),
  );

  MaterialApp(
    builder: (context, child) {
      final theme = Theme.of(context);

      return ProviderScope(
        overrides: [
          /// We override "themeProvider" with a valid theme instance.
          /// This allows providers such as "tagThemeProvider" to read the
          /// current theme, without having a BuildContext.
          themeProvider.overrideWithValue(theme),
        ],
        child: MyApp(),
      );
    },
  );
}
