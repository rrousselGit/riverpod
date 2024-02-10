import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';

final dio = Dio();

/* SNIPPET START */

final configProvider =
    StreamProvider<Configuration>((ref) => Stream.value(Configuration()));

final productsProvider = FutureProvider<List<Product>>((ref) async {
  // Listens only to the host. If something else in the configurations
  // changes, this will not pointlessly re-evaluate our provider.
  final host = await ref.watch(configProvider.selectAsync((config) => config.host));
  final result = await dio.get<List<Map<String, dynamic>>>('$host/products');

  return result.data!.map(Product.fromJson).toList();
});