import 'package:flutter_riverpod/legacy.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // We return the default sort type, here name.
  (ref) => ProductSortType.name,
);
