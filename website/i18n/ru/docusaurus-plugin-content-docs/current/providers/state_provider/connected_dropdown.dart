// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
DropdownButton<ProductSortType>(
  // При изменении типа сортировки произойдет перестройка DropdownButton
  value: ref.watch(productSortTypeProvider),
  // Обновляем состояние провайдера при взаимодействии пользователя с DropdownButton
  onChanged: (value) =>
      ref.read(productSortTypeProvider.notifier).state = value!,
  items: [
    // ...
  ],
),
/* SNIPPET END */
  ],);
}
