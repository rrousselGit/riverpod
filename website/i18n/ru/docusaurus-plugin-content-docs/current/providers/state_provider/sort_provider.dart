import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // Возвращаем тип сортировки по умолчанию (name)
  (ref) => ProductSortType.name,
);
