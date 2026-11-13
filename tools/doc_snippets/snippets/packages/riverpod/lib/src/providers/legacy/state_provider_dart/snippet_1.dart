// GENERATED from packages/riverpod/lib/src/providers/legacy/state_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/widgets.dart';

class Product {
  Product(this.id);

  final String id;
}

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super([]);
}

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.isSelected,
  });

  final Product product;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Text(product.id);
}

final selectedProductIdProvider = StateProvider<String?>((ref) => null);
final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>(
  (ref) => ProductsNotifier(),
);

Widget build(BuildContext context, WidgetRef ref) {
  final List<Product> products = ref.watch(productsProvider);
  final selectedProductId = ref.watch(selectedProductIdProvider);

  return ListView(
    children: [
      for (final product in products)
        GestureDetector(
          onTap: () =>
              ref.read(selectedProductIdProvider.notifier).state = product.id,
          child: ProductItem(
            product: product,
            isSelected: selectedProductId == product.id,
          ),
        ),
    ],
  );
}
