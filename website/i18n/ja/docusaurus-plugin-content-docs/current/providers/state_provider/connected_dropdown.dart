// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
DropdownButton<ProductSortType>(
  // ソートの種類が変わると、ドロップダウンメニューが更新されて
  // 表示されるアイコン（メニューアイテム）が変わります。
  value: ref.watch(productSortTypeProvider),
  // ユーザがドロップダウンメニューを操作するとプロバイダのステートが更新されます。
  onChanged: (value) =>
      ref.read(productSortTypeProvider.notifier).state = value!,
  items: [
    // ...
  ],
),
/* SNIPPET END */
  ]);
}
