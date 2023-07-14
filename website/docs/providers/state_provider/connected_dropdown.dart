// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
DropdownButton<ProductSortType>(
  // When the sort type changes, this will rebuild the dropdown
  // to update the icon shown.
  value: ref.watch(productSortTypeProvider),
  // When the user interacts with the dropdown, we update the provider state.
  onChanged: (value) =>
      ref.read(productSortTypeProvider.notifier).state = value!,
  items: [
    // ...
  ],
),
/* SNIPPET END */
  ]);
}
