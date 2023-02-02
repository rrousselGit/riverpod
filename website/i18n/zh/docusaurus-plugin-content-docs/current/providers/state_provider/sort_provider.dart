import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // 在这里，我们返回默认的排序类型
  (ref) => ProductSortType.name,
);
