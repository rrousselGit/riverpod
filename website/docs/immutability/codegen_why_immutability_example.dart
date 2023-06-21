import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_why_immutability_example.g.dart';

/* SNIPPET START */

class Fruit {
  Fruit({this.typeOfFruit = 'Apple'});

  String typeOfFruit;
}

@riverpod
Fruit getFruit(GetFruitRef ref) {
  return Fruit();
}

class ChangeFruitButton extends ConsumerWidget {
  const ChangeFruitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Fruit>(
      getFruitProvider,
      (Fruit? previousFruit, Fruit newFruit) {
        print('The type of fruit has changed');
      },
    );
    return ElevatedButton(
      onPressed: () {
        var fruit = ref.read<Fruit>(getFruitProvider);
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

@riverpod
FruitVendor getFruitVendor(GetFruitVendorRef ref) {
  return FruitVendor(fruitSold: Fruit());
}

class FruitVendorInfo extends ConsumerWidget {
  const FruitVendorInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fruitSold =
        ref.watch(getFruitVendorProvider.select((v) => v.fruitSold));
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
