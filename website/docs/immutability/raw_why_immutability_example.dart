import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

class Fruit {
  Fruit({this.typeOfFruit = 'Apple'});

  String typeOfFruit;
}

final fruitProvider = Provider<Fruit>((ref) {
  return Fruit();
});

class ChangeFruitButton extends ConsumerWidget {
  const ChangeFruitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Fruit>(
      fruitProvider,
      (Fruit? previousFruit, Fruit newFruit) {
        print('The type of fruit has changed');
      },
    );
    return ElevatedButton(
      onPressed: () {
        var fruit = ref.read<Fruit>(fruitProvider);
        fruit.typeOfFruit = 'Banana'; // Does not trigger listener
      },
      child: const Text('Change type of fruit'),
    );
  }
}

class FruitVendor {
  const FruitVendor({required this.fruitSold});

  final Fruit fruitSold;
}

final fruitVendorProvider = Provider<FruitVendor>((ref) {
  return FruitVendor(fruitSold: Fruit());
});

class FruitVendorInfo extends ConsumerWidget {
  const FruitVendorInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fruitSold = ref.watch(fruitVendorProvider.select((v) => v.fruitSold));
    return Column(
      children: [
        Text('Current fruit sold: ${fruitSold.typeOfFruit}'),
        ElevatedButton(
          onPressed: () {
            fruitSold.typeOfFruit = 'Banana'; // Does not trigger rebuild
          },
          child: const Text('Change fruit sold'),
        ),
      ],
    );
  }
}
