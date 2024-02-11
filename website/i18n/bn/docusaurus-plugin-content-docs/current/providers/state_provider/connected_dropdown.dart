// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';
import 'sort_provider.dart';

Widget build(BuildContext context, WidgetRef ref) {
  return AppBar(actions: [
/* SNIPPET START */
    DropdownButton<ProductSortType>(
      // যখন সর্ট টাইপ পরিবর্তিত হয়, এটি প্রদর্শিত আইকন আপডেট করতে ড্রপডাউনটি পুনর্নির্মাণ করবে।
      value: ref.watch(productSortTypeProvider),
      // যখন ব্যবহারকারী ড্রপডাউনের সাথে ইন্টারঅ্যাক্ট করে, তখন আমরা প্রভাইডারের স্টেট আপডেট করি।
      onChanged: (value) =>
          ref.read(productSortTypeProvider.notifier).state = value!,
      items: [
        // ...
      ],
    ),
/* SNIPPET END */
  ],);
}
