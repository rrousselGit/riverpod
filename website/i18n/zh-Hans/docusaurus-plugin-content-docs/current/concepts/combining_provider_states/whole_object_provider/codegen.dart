import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models.dart';

part 'codegen.g.dart';

final dio = Dio();

/* SNIPPET START */

@riverpod
Stream<Configuration> config(ConfigRef ref) => Stream.value(Configuration());

@riverpod
Future<List<Product>> products(ProductsRef ref) async {
  // Will cause productsProvider to re-fetch the products if anything in the
  // configurations changes
  final configs = await ref.watch(configProvider.future);

  final result =
      await dio.get<List<Map<String, dynamic>>>('${configs.host}/products');
  return result.data!.map(Product.fromJson).toList();
}
