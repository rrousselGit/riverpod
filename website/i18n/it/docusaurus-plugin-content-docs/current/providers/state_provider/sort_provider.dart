import 'package:flutter_riverpod/legacy.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // Restituiamo il tipo di ordinamento di default, in questo caso 'name'.
  (ref) => ProductSortType.name,
);
