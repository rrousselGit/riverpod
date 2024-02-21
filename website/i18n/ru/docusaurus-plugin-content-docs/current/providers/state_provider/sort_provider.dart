import 'package:flutter_riverpod/legacy.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // Возвращаем тип сортировки по умолчанию (name)
  (ref) => ProductSortType.name,
);
