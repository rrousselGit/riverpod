import 'package:flutter_riverpod/legacy.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // ソートの種類 name を返します。これがデフォルトのステートとなります。
  (ref) => ProductSortType.name,
);
