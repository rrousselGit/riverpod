import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// Un compteur implémenté et testé avec Dart uniquement (pas de dépendance avec Flutter)

// Nous avons déclaré un provider globalement, et nous allons l'utiliser dans deux tests,
// pour voir si l'état se réinitialise correctement à `0` entre les tests.

final counterProvider = StateProvider((ref) => 0);

// Utilisation de mockito pour garder une trace du moment où un provider notifie ses listeners
class Listener extends Mock {
  // ignore: unreachable_from_main
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // Un objet qui nous permettra de lire les providers
    // Ne le partagez pas entre les tests.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // Observer un provider et suivre les changements.
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // le listener est appelé immédiatement avec 0, la valeur par défaut
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // On incrémente la valeur
    container.read(counterProvider.notifier).state++;

    // Le listener a été appelé à nouveau, mais avec 1 cette fois-ci
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // Nous utilisons un ProviderContainer différent pour lire notre provider.
    // Cela permet de s'assurer qu'aucun état n'est réutilisé entre les tests.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // Le nouveau test utilise correctement la valeur par défaut : 0
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
