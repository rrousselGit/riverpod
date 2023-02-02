// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
    DropdownButton<ProductSortType>(
      // 当排序条件发生变化时，这将重建下拉菜单以更新显示的图标。
      value: ref.watch(productSortTypeProvider),
      // 当用户与下拉菜单交互时，我们更新 provider 的状态。
      onChanged: (value) => ref.read(productSortTypeProvider.notifier).state = value!,
      items: [
        // ...
      ],
    ),
/* SNIPPET END */
  ]);
}
