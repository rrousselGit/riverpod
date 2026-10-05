// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
    DropdownButton<ProductSortType>(
      // Wenn sich die Sortierart ändert, wird das Dropdown neu
      // erstellt um das Icon upzudaten.
      value: ref.watch(productSortTypeProvider),
      // Wenn der Nutzter mit dem Dropsdown interagiert, updaten wir den Provider Zustand.
      onChanged: (value) =>
          ref.read(productSortTypeProvider.notifier).state = value!,
      items: [
        // ...
      ],
    ),
/* SNIPPET END */
  ],);
}
