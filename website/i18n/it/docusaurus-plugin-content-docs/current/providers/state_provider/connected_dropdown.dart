// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
    DropdownButton<ProductSortType>(
      // Quando il tipo di ordinamento cambia, ricostruirà la dropdown
      // per aggiornare l'icona mostrata.
      value: ref.watch(productSortTypeProvider),
      // Quando l'utente interagisce con la dropdown aggiorniamo lo stato del provider.
      onChanged: (value) => ref.read(productSortTypeProvider.notifier).state = value!,
      items: [
        // ...
      ],
    ),
/* SNIPPET END */
  ]);
}
