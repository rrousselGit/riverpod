// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

/* SNIPPET START */
// Nous aimerions obtenir une instance de shared preferences de manière synchrone dans un provider
final countProvider = StateProvider<int>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  final currentValue = preferences.getInt('count') ?? 0;
  ref.listenSelf((prev, curr) {
    preferences.setInt('count', curr);
  });
  return currentValue;
});

// Nous n'avons pas d'instance réelle de SharedPreferences et nous ne pouvons pas en obtenir une, sauf de manière asynchrone
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

Future<void> main() async {
  // Affiche un indicateur de chargement avant de lancer l'application complète (facultatif)
  // L'écran de chargement de la plate-forme sera utilisé pendant l'attente si vous omettez cette option.
  runApp(const LoadingScreen());

  // Obtention de l'instance de shared preferences
  final prefs = await SharedPreferences.getInstance();
  return runApp(
    ProviderScope(
      overrides: [
        // Remplace le provider non implémenté par la valeur obtenue du plugin.
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utilise le provider sans s'occuper des problèmes d'asynchronisme
    final count = ref.watch(countProvider);
    return Text('$count');
  }
}
