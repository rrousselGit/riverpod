// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
    DropdownButton<ProductSortType>(
      // Sıralama türü değiştiğinde, bu, açılır menüyü yeniden oluşturacaktır
      // görüntülenen simgeyi güncellemek için.
      value: ref.watch(productSortTypeProvider),
      // Kullanıcı açılır menüyle etkileşime girdiğinde provider'ın durumunu güncelleriz.
      onChanged: (value) =>
          ref.read(productSortTypeProvider.notifier).state = value!,
      items: [
        // ...
      ],
    ),
/* SNIPPET END */
  ]);
}
