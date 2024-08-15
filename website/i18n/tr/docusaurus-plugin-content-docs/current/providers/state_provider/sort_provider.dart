import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
// Varsayılan sıralama tipini döndürüyoruz, buraya `isim'.
  (ref) => ProductSortType.name,
);
