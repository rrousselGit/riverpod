// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
DropdownButton<ProductSortType>(
  // Cuando cambia el tipo de clasificación, esto reconstruirá el dropdown 
  // para actualizar el icono que se muestra.
  value: ref.watch(productSortTypeProvider),
  // Cuando el usuario interactúa con el dropdown, actualizamos el estado del provider.
  onChanged: (value) =>
      ref.read(productSortTypeProvider.notifier).state = value!,
  items: [
    // ...
  ],
),
/* SNIPPET END */
  ]);
}
