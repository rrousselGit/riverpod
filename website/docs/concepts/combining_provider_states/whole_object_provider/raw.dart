import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';

final dio = Dio();

/* SNIPPET START */

final configProvider =
    StreamProvider<Configuration>((ref) => Stream.value(Configuration()));

final productsProvider = FutureProvider<List<Product>>((ref) async {
  // Will cause productsProvider to re-fetch the products if anything in the
  // configurations changes
  final configs = await ref.watch(configProvider.future);

  return dio.get('${configs.host}/products');
});
