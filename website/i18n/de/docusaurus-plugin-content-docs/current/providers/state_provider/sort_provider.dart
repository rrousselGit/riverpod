import 'package:flutter_riverpod/legacy.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // Wir returnen die default Sortierart, in diesem Fall den Namen.
  (ref) => ProductSortType.name,
);
