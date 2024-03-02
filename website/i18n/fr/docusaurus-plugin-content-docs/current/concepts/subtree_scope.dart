// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

/// Un compteur qui est incrémenté par chaque bouton "ElevatedButton" de [CounterDisplay].
final counterProvider = StateProvider(
  (ref) => 0,
);

final adjustedCountProvider = Provider(
  (ref) => ref.watch(counterProvider) * 2,
  // Notez que si un provider dépend d'un provider qui est surchargé pour un sous-arbre,
  // vous devez explicitement lister ce provider dans votre liste de dépendances.
  dependencies: [counterProvider],
);

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Column(
      children: [
        ProviderScope(
          /// Il suffit de spécifier le provider dont vous voulez avoir une copie dans le sous-arbre.
          ///
          /// Notez que les providers dépendants, tels que [adjustedCountProvider],
          /// seront également copiés pour ce sous-arbre. Si ce n'est pas le comportement que vous souhaitez,
          /// envisagez d'utiliser des familles à la place
          overrides: [counterProvider],
          child: const CounterDisplay(),
        ),
        ProviderScope(
          // 
          // Vous pouvez modifier le comportement du provider dans un sous-arbre particulier.
          overrides: [counterProvider.overrideWith((ref) => 1)],
          child: const CounterDisplay(),
        ),
        ProviderScope(
          overrides: [
            counterProvider,
            // Vous pouvez également modifier les comportements des providers dépendants
            adjustedCountProvider.overrideWith(
              (ref) => ref.watch(counterProvider) * 3,
            ),
          ],
          child: const CounterDisplay(),
        ),
        // Cet affichage particulier utilisera l'état du provider à partir du ProviderScope racine.
        const CounterDisplay(),
      ],
    ));
  }
}

class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: const Text('Incrémenter le compteur'),
        ),
      ],
    );
  }
}
