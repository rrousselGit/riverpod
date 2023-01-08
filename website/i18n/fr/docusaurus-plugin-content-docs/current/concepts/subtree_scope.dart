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
<<<<<<< HEAD
  // Notez que si un provider dépend d'un provider qui est surchargé pour un sous-arbre, 
  // vous devez explicitement lister ce provider dans votre liste de dépendances.
=======
  // Notez que si un provider dépend d'un provider qui est surchargé pour un sous-arbre,
  // vous devez explicitement lister ce fournisseur dans votre liste de dépendances.
>>>>>>> 01f66c936e312493a4bf6ef40a9254827c7eed99
  dependencies: [counterProvider],
);

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Column(
      children: [
        ProviderScope(
<<<<<<< HEAD
          /// Notez que les providers dépendants tels que [adjustedCountProvider] seront également copiés pour ce sous-arbre. 
          /// 
          /// Si ce n'est pas le comportement que vous souhaitez, 
          /// envisagez d'utiliser plutôt les familles
=======
          /// Il suffit de spécifier le provider dont vous voulez avoir une copie dans le sous-arbre.
          ///
          /// Notez que les providers dépendants, tels que [adjustedCountProvider],
          /// seront également copiés pour ce sous-arbre. Si ce n'est pas le comportement que vous souhaitez,
          /// envisagez d'utiliser des familles à la place
>>>>>>> 01f66c936e312493a4bf6ef40a9254827c7eed99
          overrides: [counterProvider],
          child: const CounterDisplay(),
        ),
        ProviderScope(
<<<<<<< HEAD
=======
          // 
>>>>>>> 01f66c936e312493a4bf6ef40a9254827c7eed99
          // Vous pouvez modifier le comportement du provider dans un sous-arbre particulier.
          overrides: [counterProvider.overrideWith((ref) => 1)],
          child: const CounterDisplay(),
        ),
        ProviderScope(
          overrides: [
            counterProvider,
<<<<<<< HEAD
            // Vous pouvez également modifier les comportements des prestataires dépendants
=======
            // Vous pouvez également modifier les comportements des providers dépendants
>>>>>>> 01f66c936e312493a4bf6ef40a9254827c7eed99
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
  const CounterDisplay({Key? key}) : super(key: key);

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
<<<<<<< HEAD
          child: const Text('Increment Count'),
=======
          child: const Text('Incrémenter le compteur'),
>>>>>>> 01f66c936e312493a4bf6ef40a9254827c7eed99
        ),
      ],
    );
  }
}
