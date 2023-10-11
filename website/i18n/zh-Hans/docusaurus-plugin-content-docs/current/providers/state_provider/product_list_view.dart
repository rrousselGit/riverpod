import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product.dart';

/* SNIPPET START */

Widget build(BuildContext context, WidgetRef ref) {
  final products = ref.watch(productsProvider);
  return Scaffold(
    body: ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('${product.price} \$'),
        );
      },
    ),
  );
}
