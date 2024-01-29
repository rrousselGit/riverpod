
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
  // Listens only to the host. If something else in the configurations
  // changes, this will not pointlessly re-evaluate our provider.
  final host = await ref.watch(configProvider.selectAsync((config) => config.host));

  final result = await dio.get<List<Map<String, dynamic>>>('$host/products');

  return result.data!.map(Product.fromJson).toList();
}
