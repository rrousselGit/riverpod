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
final countProvider = NotifierProvider<CountNotifier, int>(CountNotifier.new);

class CountNotifier extends Notifier<int> {
  @override
  int build() {
    // We'd like to obtain an instance of shared preferences synchronously in a provider
    final preferences = ref.watch(sharedPreferencesProvider);
    final currentValue = preferences.getInt('count') ?? 0;
    listenSelf((prev, next) {
      preferences.setInt('count', next);
    });
    return currentValue;
  }

  void increment() => state++;
}

// We don't have an actual instance of SharedPreferences, and we can't get one except asynchronously
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

Future<void> main() async {
  // Show a loading indicator before running the full app (optional)
  // The platform's loading screen will be used while awaiting if you omit this.
  runApp(const LoadingScreen());

  // Get the instance of shared preferences
  final prefs = await SharedPreferences.getInstance();
  return runApp(
    ProviderScope(
      overrides: [
        // Override the unimplemented provider with the value gotten from the plugin
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
    // Use the provider without dealing with async issues
    final count = ref.watch(countProvider);
    return Text('$count');
  }
}
