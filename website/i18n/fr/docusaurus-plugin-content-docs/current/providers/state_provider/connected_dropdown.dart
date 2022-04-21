// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  /* SNIPPET START */
  return AppBar(actions: [
    DropdownButton<ProductSortType>(
      // Lorsque le type de tri change, le dropdown est
      // reconstruite pour mettre à jour l'icône affichée.
      value: ref.watch(productSortTypeProvider),
      // Lorsque l'utilisateur interagit avec le dropdown,
      // on met à jour l'état (state) du provider.
      onChanged: (value) =>
          ref.read(productSortTypeProvider.notifier).state = value!,
      items: [
        // ...
      ],
    ),
    /* SNIPPET END */
  ]);
}
