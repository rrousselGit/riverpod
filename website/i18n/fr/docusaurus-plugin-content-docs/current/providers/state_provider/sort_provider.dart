import 'package:flutter_riverpod/legacy.dart';

import 'dropdown.dart';

/* SNIPPET START */

final productSortTypeProvider = StateProvider<ProductSortType>(
  // On retourne le type de tri par défaut, ici nom.
  (ref) => ProductSortType.name,
);
